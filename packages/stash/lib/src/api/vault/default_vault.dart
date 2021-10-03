import 'dart:async';

import 'package:clock/clock.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault.dart';
import 'package:stash/src/api/vault_entry.dart';
import 'package:stash/src/api/vault_stat.dart';
import 'package:uuid/uuid.dart';

/// Default implementation of the [Vault] interface
class DefaultVault<T> implements Vault<T> {
  /// The name of this vault
  final String name;

  /// The [Store] for this vault
  final Store<VaultStat, VaultEntry> storage;

  /// The source of time to be used on this vault
  final Clock clock;

  /// Builds a [DefaultVault] out of a mandatory [Store] and a set of
  /// optional configurations
  ///
  /// * [storage]: The [Store]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  ///
  /// Returns a [DefaultVault]
  DefaultVault(this.storage, {String? name, Clock? clock})
      : name = name ?? Uuid().v1(),
        clock = clock ?? Clock();

  /// Gets the vault storage size
  ///
  /// Returns the vault size
  Future<int> _getStorageSize() {
    return storage.size(name);
  }

  /// Gets a vault entry from storage
  ///
  /// * [key]: the vault key to retrieve from the underlining storage
  ///
  /// Returns the vault entry
  Future<VaultEntry?> _getStorageEntry(String key) {
    return storage.getEntry(name, key);
  }

  /// Puts a vault entry identified by [key] on the configured [Store]
  ///
  /// * [key]: The vault key
  /// * [entry]: The vault entry
  /// * [event]: An optional event
  Future<void> _putStorageEntry(String key, VaultEntry entry) {
    if (entry.valueChanged) {
      return storage.putEntry(name, key, entry);
    } else {
      return storage.setStat(name, key, entry.stat);
    }
  }

  /// Removes the stored [VaultEntry] for the specified [key].
  ///
  /// * [key]: The vault key
  /// * [event]: The event
  Future<void> _removeStorageEntry(String key) {
    return storage.remove(name, key);
  }

  /// Clear the vault storage
  Future<void> _clearStorage() {
    return storage.clear(name);
  }

  @override
  Future<int> get size {
    return _getStorageSize();
  }

  @override
  Future<Iterable<String>> get keys => storage.keys(name);

  @override
  Future<bool> containsKey(String key) {
    return _getStorageEntry(key).then((entry) => entry != null);
  }

  /// Puts the value in the vault.
  ///
  /// * [key]: the vault key
  /// * [value]: the vault value
  /// * [now]: the current date/time
  Future<bool> _putEntry(String key, T value, DateTime now) {
    final entry = VaultEntry.newEntry(key, now, value);

    return _putStorageEntry(key, entry).then((v) => true);
  }

  /// Returns the vault entry value updating the vault statistics i.e. updates
  /// [VaultEntry.accessTime] with the access time
  ///
  /// * [entry]: the [VaultEntry] holding the value
  /// * [now]: the current date/time
  Future<T> _getEntryValue(VaultEntry entry, DateTime now) {
    entry.accessTime = now;

    // Store the entry changes and return the value
    return _putStorageEntry(entry.key, entry).then((v) => entry.value);
  }

  /// Updates the entry value and the vault statistics namely it updates the
  /// [VaultEntry.updateTime] with the update time
  ///
  /// * [entry]: the [VaultEntry] holding the value
  /// * [value]: the new value
  /// * [now]: the current date/time
  Future<T> _updateEntry(VaultEntry entry, T value, DateTime now) {
    final newEntry = entry.updateEntry(value, updateTime: now);

    // Store the entry in the underlining storage
    return _putStorageEntry(entry.key, newEntry).then((v) => entry.value);
  }

  @override
  Future<T?> get(String key) {
    // Gets the entry from the storage
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        final now = clock.now();
        return _getEntryValue(entry, now);
      }

      return null;
    });
  }

  @override
  Future<void> put(String key, T value, {Duration? expiryDuration}) {
    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();

      // If the entry does not exist
      if (entry == null) {
        // And finally we add it to the vault
        return _putEntry(key, value, now).then((_) => null);
      } else {
        // Already present let's update the vault instead
        return _updateEntry(entry, value, now).then((_) => null);
      }
    });
  }

  @override
  Future<T?> operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, T value, {Duration? expiryDuration}) {
    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      // If the entry is non existent
      if (entry == null) {
        final now = clock.now();
        return _putEntry(key, value, now);
      }

      return Future.value(false);
    });
  }

  @override
  Future<void> clear() {
    return _clearStorage();
  }

  /// Removes a entry from storage by [key]
  ///
  /// * [key]: key whose mapping is to be removed from the vault
  Future<void> _removeEntryByKey(String key) {
    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        return _removeStorageEntry(key);
      }

      // Do nothing the entry does not exist
      return Future.value();
    });
  }

  @override
  Future<void> remove(String key) {
    return _removeEntryByKey(key);
  }

  @override
  Future<T?> getAndPut(String key, T value) {
    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      // If the entry does not exist
      if (entry == null) {
        return _putEntry(key, value, now).then((v) => null);
      } else {
        return _updateEntry(entry, value, now);
      }
    });
  }

  @override
  Future<T?> getAndRemove(String key) {
    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        // The entry exists on vault
        return _removeStorageEntry(key).then((value) => entry.value);
      }

      return Future.value();
    });
  }
}
