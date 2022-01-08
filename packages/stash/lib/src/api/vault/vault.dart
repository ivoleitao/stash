import 'package:stash/src/api/vault/event/event.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_manager.dart';
import 'package:stash/src/api/vault/vault_stats.dart';

import '../stash.dart';

/// Vault entry delegate
typedef VaultEntryDelegate<T> = VaultEntryBuilder<T> Function(
    VaultEntryBuilder<T> delegate);

/// The vault definition and the hub for the creation of Vaults
abstract class Vault<T> extends Stash<T> {
  /// Gets the [VaultManager] that owns and manages the [Vault].
  /// Returns the manager or `null` if the [Vault] is not managed
  VaultManager? get manager;

  // If the statistics should be collected
  bool get statsEnabled;

  // Gets the vault stats
  VaultStats get stats;

  /// Add / Replace the vault [value] for the specified [key].
  ///
  /// * [key]: the key
  /// * [value]: the value
  /// * [delegate]: provides the caller a way of changing the [VaultEntry] before persistence
  @override
  Future<void> put(String key, T value, {VaultEntryDelegate<T>? delegate});

  /// Associates the specified [key] with the given [value]
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [delegate]: provides the caller a way of changing the [VaultEntry] before persistence
  ///
  /// Returns `true` if a value was set.
  @override
  Future<bool> putIfAbsent(String key, T value,
      {VaultEntryDelegate<T>? delegate});

  /// Associates the specified [value] with the specified [key] in this cache,
  /// returning an existing value if one existed. If the cache previously contained
  /// a mapping for the [key], the old value is replaced by the specified value.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [delegate]: provides the caller a way of changing the [VaultEntry] before persistence
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  @override
  Future<T?> getAndPut(String key, T value, {VaultEntryDelegate<T>? delegate});

  /// Listens for events of Type `T` and its subtypes.
  ///
  /// The method is called like this: myVault.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Stream] contains every
  /// event of this [Vault].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  Stream<E> on<E extends VaultEvent<T>>();
}
