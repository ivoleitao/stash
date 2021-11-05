import 'dart:async';

import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/event/created_event.dart';
import 'package:stash/src/api/vault/event/event.dart';
import 'package:stash/src/api/vault/event/removed_event.dart';
import 'package:stash/src/api/vault/event/updated_event.dart';
import 'package:stash/src/api/vault/stats/default_stats.dart';
import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_info.dart';
import 'package:uuid/uuid.dart';

import 'vault_manager.dart';
import 'vault_stats.dart';

/// Default implementation of the [Vault] interface
class DefaultVault<T> implements Vault<T> {
  /// The name of this vault
  @override
  final String name;

  @override
  final VaultManager? manager;

  /// The [Store] for this vault
  final Store<VaultInfo, VaultEntry> storage;

  /// The source of time to be used on this vault
  final Clock clock;

  /// The [StreamController] for this vault events
  final StreamController streamController;

  /// The event publishing mode of this vault
  final EventListenerMode eventPublishingMode;

  @override
  final bool statsEnabled;

  @override
  final VaultStats stats;

  /// Builds a [DefaultVault] out of a mandatory [Store] and a set of
  /// optional configurations
  ///
  /// * [storage]: The [Store]
  /// * [manager]: An optional [VaultManager]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance, defaults to [DefaultVaultStats]
  ///
  /// Returns a [DefaultVault]
  DefaultVault(this.storage,
      {this.manager,
      String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats})
      : name = name ?? Uuid().v1(),
        clock = clock ?? Clock(),
        eventPublishingMode = eventListenerMode ?? EventListenerMode.disabled,
        streamController = StreamController.broadcast(
            sync: eventListenerMode == EventListenerMode.synchronous),
        statsEnabled = statsEnabled ?? false,
        stats = stats ?? DefaultVaultStats();

  /// Fires a new event on the event bus with the specified [event].
  void _fire(VaultEvent<T>? event) {
    if (eventPublishingMode != EventListenerMode.disabled && event != null) {
      streamController.add(event);
    }
  }

  @override
  Stream<E> on<E extends VaultEvent<T>>() {
    if (E == dynamic) {
      return streamController.stream as Stream<E>;
    } else {
      return streamController.stream.where((event) => event is E).cast<E>();
    }
  }

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
  Future<void> _putStorageEntry(String key, VaultEntry entry,
      {VaultEvent<T>? event}) {
    if (entry.valueChanged) {
      return storage.putEntry(name, key, entry).then((_) => _fire(event));
    } else {
      return storage.setInfo(name, key, entry.info);
    }
  }

  /// Removes the stored [VaultEntry] for the specified [key].
  ///
  /// * [key]: The vault key
  /// * [event]: The event
  Future<void> _removeStorageEntry(String key, VaultEvent<T> event) {
    return storage.remove(name, key).then((_) => _fire(event));
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
    return _getStorageEntry(key).then((entry) {
      return entry != null;
    });
  }

  /// Puts the value in the vault.
  ///
  /// * [key]: the vault key
  /// * [value]: the vault value
  /// * [now]: the current date/time
  Future<void> _putEntry(String key, T value, DateTime now) {
    final entry = VaultEntry.newEntry(key, now, value);

    return _putStorageEntry(key, entry,
        event: VaultEntryCreatedEvent<T>(this, entry));
  }

  /// Returns the vault entry value updating the vault info i.e. updates
  /// [VaultEntry.accessTime] with the access time
  ///
  /// * [entry]: the [VaultEntry] holding the value
  /// * [now]: the current date/time
  Future<T> _getEntryValue(VaultEntry entry, DateTime now) {
    entry.accessTime = now;
    // Store the entry changes and return the value
    return _putStorageEntry(entry.key, entry).then((_) => entry.value);
  }

  /// Updates the entry value and the vault info: the
  /// [VaultEntry.updateTime] with the update time
  /// in place for this vault entry
  ///
  /// * [entry]: the [VaultEntry] holding the value
  /// * [value]: the new value
  /// * [now]: the current date/time
  Future<T> _updateEntry(VaultEntry entry, T value, DateTime now) {
    final newEntry = entry.updateEntry(value, updateTime: now);

    // Finally store the entry in the underlining storage
    return _putStorageEntry(entry.key, newEntry,
            event: VaultEntryUpdatedEvent<T>(this, entry, newEntry))
        .then((_) => entry.value);
  }

  @override
  Future<T?> get(String key) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<T?> Function(T? value) posGet = (T? value) => Future.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (T? value) {
        stats.increaseGets();
        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future.value(value);
      };
    }
    // #endregion

    // Gets the entry from the storage
    return _getStorageEntry(key).then((entry) {
      // Does this entry exists ?
      if (entry == null) {
        return Future<T?>.value();
      } else {
        return _getEntryValue(entry, now);
      }
    }).then(posGet);
  }

  @override
  Future<void> put(String key, T value) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<void> Function(dynamic) posPut = (_) => Future<void>.value();
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posPut = (_) {
        stats.increasePuts();

        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion

    // Try to get the entry from the vault
    return _getStorageEntry(key).then((entry) {
      // If the entry does not exist
      if (entry == null) {
        // And finally we add it to the vault
        return _putEntry(key, value, now);
      } else {
        // Already present let's update the vault instead
        return _updateEntry(entry, value, now);
      }
    }).then(posPut);
  }

  @override
  Future<T?> operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, T value) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<VaultEntry?> Function(VaultEntry? entry) posGet =
        (VaultEntry? entry) => Future.value(entry);
    Future<bool> Function(bool) posPut = (bool ok) => Future<bool>.value(ok);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (VaultEntry? entry) {
        stats.increaseGets();

        return Future.value(entry);
      };
      posPut = (bool ok) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<bool>.value(ok);
      };
    }
    // #endregion

    // Try to get the entry from the vault
    return _getStorageEntry(key).then(posGet).then((entry) {
      // If the entry does not exist
      if (entry == null) {
        return _putEntry(key, value, now).then((_) => posPut(true));
      }

      return posPut(false);
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
        // The entry exists on vault let's remove and send and removed event
        return _removeStorageEntry(key, VaultEntryRemovedEvent<T>(this, entry));
      }

      // Do nothing the entry does not exist
      return Future.value();
    });
  }

  @override
  Future<void> remove(String key) {
    // #region Statistics
    Stopwatch? watch;
    Future<void> Function(dynamic) posRemove = (_) => Future<void>.value();
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posRemove = (_) {
        stats.increaseRemovals();
        if (watch != null) {
          stats.addRemoveTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion
    return _removeEntryByKey(key).then(posRemove);
  }

  @override
  Future<T?> getAndPut(String key, T value) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<VaultEntry?> Function(VaultEntry? entry) posGet =
        (VaultEntry? entry) => Future.value(entry);
    Future<T?> Function(T? value) posPut =
        (T? value) => Future<T?>.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (VaultEntry? entry) {
        stats.increaseGets();

        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
        }

        return Future.value(entry);
      };
      posPut = (T? value) {
        stats.increasePuts();

        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<T?>.value();
      };
    }
    // #endregion

    // Try to get the entry from the vault
    return _getStorageEntry(key).then(posGet).then((entry) {
      // If the entry does not exist
      if (entry == null) {
        return _putEntry(key, value, now).then((_) => posPut(null));
      } else {
        return _updateEntry(entry, value, now).then(posPut);
      }
    });
  }

  @override
  Future<T?> getAndRemove(String key) {
    // #region Statistics
    Stopwatch? watch;
    Future<VaultEntry?> Function(VaultEntry? entry) posGet =
        (VaultEntry? entry) => Future.value(entry);
    Future<T?> Function(VaultEntry entry) posRemove =
        (VaultEntry entry) => Future<T?>.value(entry.value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (VaultEntry? entry) {
        stats.increaseGets();

        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
        }

        return Future.value(entry);
      };
      posRemove = (VaultEntry entry) {
        stats.increaseRemovals();
        if (watch != null) {
          stats.addRemoveTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<T?>.value(entry.value);
      };
    }
    // #endregion

    // Try to get the entry from the vault
    return _getStorageEntry(key).then(posGet).then((entry) {
      if (entry != null) {
        // The entry exists on vault
        return _removeStorageEntry(key, VaultEntryRemovedEvent<T>(this, entry))
            .then((_) => posRemove(entry));
      }

      return Future<T?>.value();
    });
  }
}
