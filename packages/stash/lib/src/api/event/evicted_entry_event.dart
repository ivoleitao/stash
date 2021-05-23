import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

import 'removed_entry_event.dart';

/// A Cache entry evicted event
class EvictedEntryEvent extends RemovedEntryEvent {
  /// Builds a [EvictedEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The evicted entry
  EvictedEntryEvent(Cache source, CacheEntry entry)
      : super(source, entry, type: EntryEventType.EVICTED);
}
