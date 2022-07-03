import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/event.dart';

/// The type of event received by the listener.
enum CacheEventType {
  /// An event type indicating that the cache entry was created.
  created,

  /// An event type indicating that the cache entry was updated.
  updated,

  /// An event type indicating that the cache entry was removed.
  removed,

  /// An event type indicating that the cache entry was expired.
  expired,

  /// An event type indicating that the cache entry was evicted
  evicted
}

/// A Cache event
abstract class CacheEvent<T> extends StashEvent<T, CacheEventType, Cache<T>> {
  /// Builds a [CacheEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [type]: The event type
  CacheEvent(super.source, super.type);
}
