import 'package:stash/src/api/cache.dart';

import 'event.dart';

/// The type of event received by the listener.
enum EntryEventType {
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

/// A Cache entry event base class.
abstract class CacheEntryEvent extends CacheEvent {
  /// The event type of this event
  final EntryEventType type;

  /// Builds a [CacheEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [type]: The event type
  CacheEntryEvent(Cache source, this.type) : super(source);
}
