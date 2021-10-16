import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';

import 'event.dart';

/// A Cache entry updated event
class CacheEntryUpdatedEvent<T> extends CacheEvent<T> {
  /// The old entry
  final CacheEntry oldEntry;

  /// The new entry
  final CacheEntry newEntry;

  /// Builds a [CacheEntryUpdatedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [oldEntry]: The old entry
  /// * [newEntry]: The new entry
  CacheEntryUpdatedEvent(Cache<T> source, this.oldEntry, this.newEntry)
      : super(source, CacheEventType.updated);
}
