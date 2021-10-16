import 'package:clock/clock.dart';
import 'package:stash/src/api/vault/default_vault.dart';
import 'package:stash/src/api/vault/event/event.dart';
import 'package:stash/stash_api.dart';

import '../stash.dart';
import '../store.dart';
import 'vault_entry.dart';
import 'vault_info.dart';
import 'vault_stats.dart';

/// The vault definition and the hub for the creation of Vaults
abstract class Vault<T> extends Stash<T> {
  /// The default constructor
  Vault();

  /// Builds a new Vault
  ///
  /// * [storage]: The [Store] that will back this [Vault]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this vault
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a new [DefaultVault]
  factory Vault.newVault(Store<VaultInfo, VaultEntry> storage,
      {String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return DefaultVault<T>(storage,
        name: name,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

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
