import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_info.dart';

import 'event.dart';

/// A cache entry removed event
class CacheEntryRemovedEvent<T> extends CacheEvent<T> {
  /// The removed entry
  final CacheInfo entry;

  /// Builds a [CacheEntryRemovedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The removed entry
  /// * [type]: The event type
  CacheEntryRemovedEvent(Cache<T> source, this.entry, {CacheEventType? type})
      : super(source, type ?? CacheEventType.removed);
}
