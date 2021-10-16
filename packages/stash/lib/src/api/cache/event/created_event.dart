import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';

import 'event.dart';

/// The entry created event
class CacheEntryCreatedEvent<T> extends CacheEvent<T> {
  /// The created entry
  final CacheEntry entry;

  /// Builds a [CacheEntryCreatedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The created entry
  CacheEntryCreatedEvent(Cache<T> source, this.entry)
      : super(source, CacheEventType.created);
}
