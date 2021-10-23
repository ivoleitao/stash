import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/default_vault.dart';
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
  /// * [storage]: The [Store] that will back this [Vault]
  /// * [manager]: An optional [VaultManager]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this vault
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a new [DefaultVault]
  Vault<T> newVault<T>(Store<VaultInfo, VaultEntry> storage,
      {VaultManager manager,
      String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats});

  /// Gets an existing [Vault]
  ///
  /// * [name]: The name of the vault
  Vault<T>? get<T>(String name);

  /// Removes a [Vault] from this [VaultManager] if present
  ///
  /// * [name]: The name of the vault
  void remove(String name);
}
