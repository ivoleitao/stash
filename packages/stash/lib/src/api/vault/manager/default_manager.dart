import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/generic_preferences.dart';
import 'package:stash/src/api/vault/generic_vault.dart';
import 'package:stash/src/api/vault/preferences.dart';
import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_info.dart';
import 'package:stash/src/api/vault/vault_manager.dart';
import 'package:stash/src/api/vault/vault_stats.dart';

class DefaultVaultManager extends VaultManager {
  /// The list of vaults
  final _vaults = <String, Vault>{};

  @override
  Iterable<String> get names => _vaults.keys;

  @override
  Vault<T> newGenericVault<T>(Store<VaultInfo, VaultEntry> storage,
      {String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    final vault = GenericVault<T>(storage,
        manager: this,
        name: name,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
    _vaults[vault.name] = vault;

    return vault;
  }

  @override
  Preferences newPreferencesVault(Store<VaultInfo, VaultEntry> storage,
      {String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    final vault = GenericPreferences(storage,
        manager: this,
        name: name,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);

    _vaults[vault.name] = vault;

    return vault;
  }

  @override
  V? get<T, V extends Vault<T>>(String name) {
    return _vaults[name] as V?;
  }

  @override
  void remove(String name) {
    _vaults.remove(name);
  }
}
