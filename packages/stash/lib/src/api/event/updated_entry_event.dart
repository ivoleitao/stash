import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

/// A Cache entry updated event
class UpdatedEntryEvent extends CacheEntryEvent {
  /// The old entry
  final CacheEntry oldEntry;

  /// The new entry
  final CacheEntry newEntry;

  /// Builds a [UpdatedEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [oldEntry]: The old entry
  /// * [newEntry]: The new entry
  UpdatedEntryEvent(Cache source, this.oldEntry, this.newEntry)
      : super(source, EntryEventType.UPDATED);
}
