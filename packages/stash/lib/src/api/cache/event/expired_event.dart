import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';

import 'event.dart';
import 'removed_event.dart';

/// A cache entry expired event
class CacheEntryExpiredEvent<T> extends CacheEntryRemovedEvent<T> {
  /// Builds a [CacheEntryExpiredEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The removed entry
  CacheEntryExpiredEvent(Cache<T> source, CacheEntry entry)
      : super(source, entry, type: CacheEventType.expired);
}
