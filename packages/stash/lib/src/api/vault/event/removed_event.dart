import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';

import 'event.dart';

/// A vault entry removed event
class VaultEntryRemovedEvent<T> extends VaultEvent<T> {
  /// The removed entry
  final VaultEntry entry;

  /// Builds a [VaultEntryRemovedEvent]
  ///
  /// * [source]: The vault that originated the event
  /// * [entry]: The removed entry
  VaultEntryRemovedEvent(Vault<T> source, this.entry)
      : super(source, VaultEventType.removed);
}
