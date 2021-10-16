import 'package:stash/src/api/vault/vault.dart';
import 'package:stash/src/api/vault/vault_entry.dart';

import 'event.dart';

/// The entry created event
class VaultEntryCreatedEvent<T> extends VaultEvent<T> {
  /// The created entry
  final VaultEntry entry;

  /// Builds a [VaultEntryCreatedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The created entry
  VaultEntryCreatedEvent(Vault<T> source, this.entry)
      : super(source, VaultEventType.created);
}
