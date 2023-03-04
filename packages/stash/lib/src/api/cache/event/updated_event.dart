import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_info.dart';

import 'event.dart';

/// A Cache entry updated event
class CacheEntryUpdatedEvent<T> extends CacheEvent<T> {
  /// The old entry
  final CacheInfo oldEntry;

  /// The new entry
  final CacheEntry newEntry;

  /// Builds a [CacheEntryUpdatedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [oldEntry]: The old entry info
  /// * [newEntry]: The new entry
  CacheEntryUpdatedEvent(Cache<T> source, this.oldEntry, this.newEntry)
      : super(source, CacheEventType.updated);
}
