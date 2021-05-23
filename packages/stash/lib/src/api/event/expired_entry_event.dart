import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

import 'removed_entry_event.dart';

/// A Cache entry expired event
class ExpiredEntryEvent extends RemovedEntryEvent {
  /// Builds a [ExpiredEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The removed entry
  ExpiredEntryEvent(Cache source, CacheEntry entry)
      : super(source, entry, type: EntryEventType.EXPIRED);
}
