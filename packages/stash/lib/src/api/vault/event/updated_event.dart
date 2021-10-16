import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';

import 'event.dart';

/// A Vault entry updated event
class VaultEntryUpdatedEvent<T> extends VaultEvent<T> {
  /// The old entry
  final VaultEntry oldEntry;

  /// The new entry
  final VaultEntry newEntry;

  /// Builds a [VaultEntryUpdatedEvent]
  ///
  /// * [source]: The vault that originated the event
  /// * [oldEntry]: The old entry
  /// * [newEntry]: The new entry
  VaultEntryUpdatedEvent(Vault<T> source, this.oldEntry, this.newEntry)
      : super(source, VaultEventType.updated);
}
