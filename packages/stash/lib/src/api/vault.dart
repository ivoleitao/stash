import 'package:clock/clock.dart';
import 'package:stash/src/api/vault/default_vault.dart';

import 'stash.dart';
import 'store.dart';
import 'vault_entry.dart';
import 'vault_stat.dart';

/// The vault definition and the hub for the creation of Vaults
abstract class Vault<T> extends Stash<T> {
  /// The default constructor
  Vault();

  /// Builds a new Vault
  ///
  /// * [storage]: The [Store] that will back this [Vault]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  ///
  /// Returns a new [DefaultVault]
  factory Vault.newVault(Store<VaultStat, VaultEntry> storage,
      {String? name, Clock? clock}) {
    return DefaultVault<T>(storage, name: name, clock: clock);
  }
}
