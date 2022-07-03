import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/generic_vault.dart';
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
  Future<Vault<T>> newGenericVault<T>(Store<VaultInfo, VaultEntry> store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    final vault = GenericVault<T>(store,
        manager: this,
        name: name,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
    _vaults[vault.name] = vault;

    return store
        .create(vault.name, fromEncodable: fromEncodable)
        .then((_) => vault);
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
