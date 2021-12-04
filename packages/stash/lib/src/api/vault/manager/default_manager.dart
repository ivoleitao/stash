import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/default_vault.dart';
import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_info.dart';
import 'package:stash/src/api/vault/vault_manager.dart';
import 'package:stash/src/api/vault/vault_stats.dart';

class DefaultVaultManager implements VaultManager {
  /// The list of vaults
  final _vaults = <String, Vault>{};

  @override
  Iterable<String> get names => _vaults.keys;

  @override
  Vault<T> newVault<T>(Store<VaultInfo, VaultEntry> storage,
      {String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    final vault = DefaultVault<T>(storage,
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
  Vault<T>? get<T>(String name) {
    return _vaults[name] as Vault<T>?;
  }

  @override
  void remove(String name) {
    _vaults.remove(name);
  }
}
