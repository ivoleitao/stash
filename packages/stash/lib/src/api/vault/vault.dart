import 'package:stash/src/api/vault/event/event.dart';
import 'package:stash/stash_api.dart';

import '../stash.dart';

/// The vault definition and the hub for the creation of Vaults
abstract class Vault<T> extends Stash<T> {
  // VaultManager getVaultManager();

  /// Gets the [VaultManager] that owns and manages the [Vault].
  /// Returns the manager or `null` if the [Vault] is not managed
  VaultManager? get manager;

  // If the statistics should be collected
  bool get statsEnabled;

  // Gets the vault stats
  VaultStats get stats;

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
