import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';

import 'event.dart';
import 'removed_event.dart';

/// A cache entry evicted event
class CacheEntryEvictedEvent<T> extends CacheEntryRemovedEvent<T> {
  /// Builds a [CacheEntryEvictedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The evicted entry
  CacheEntryEvictedEvent(Cache<T> source, CacheEntry entry)
      : super(source, entry, type: CacheEventType.evicted);
}
