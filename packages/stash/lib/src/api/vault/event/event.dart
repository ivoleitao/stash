import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/vault/vault.dart';

/// The type of event received by the listener.
enum VaultEventType {
  /// An event type indicating that the vault entry was created.
  created,

  /// An event type indicating that the vault entry was updated.
  updated,

  /// An event type indicating that the vault entry was removed.
  removed
}

/// A Cache event
abstract class VaultEvent<T> extends StashEvent<T, VaultEventType, Vault<T>> {
  /// Builds a [VaultEvent]
  ///
  /// * [source]: The vault that originated the event
  /// * [type]: The event type
  VaultEvent(super.source, super.type);
}
