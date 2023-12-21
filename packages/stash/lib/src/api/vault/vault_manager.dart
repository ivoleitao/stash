import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/generic_vault.dart';
import 'package:stash/src/api/vault/manager/default_manager.dart';
import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_info.dart';
import 'package:stash/src/api/vault/vault_stats.dart';

abstract class VaultManager {
  /// The default instance of the [VaultManager]
  static final VaultManager instance = DefaultVaultManager();

  /// Returns a [Iterable] over all the [Vault] names
  Iterable<String> get names;

  /// Builds a new Vault
  ///
  /// * [store]: The [Store] that will back this [Vault]
  /// * [name]: The name of the vault
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [vaultLoader]: The [VaultLoader] that should be used to fetch a new value upon absence
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this vault
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a new [GenericVault]
  Future<Vault<T>> newGenericVault<T>(Store<VaultInfo, VaultEntry> store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      VaultLoader<T>? vaultLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats});

  /// Gets an existing [Vault]
  ///
  /// * [name]: The name of the vault
  V? get<T, V extends Vault<T>>(String name);

  /// Gets an existing [Vault]
  ///
  /// * [name]: The name of the cache
  Vault<T>? getVault<T>(String name) {
    return get<T, Vault<T>>(name);
  }

  /// Removes a [Vault] from this [VaultManager] if present
  ///
  /// * [name]: The name of the vault
  void remove(String name);
}
