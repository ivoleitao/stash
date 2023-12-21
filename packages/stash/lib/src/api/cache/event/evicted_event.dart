import 'event.dart';
import 'removed_event.dart';

/// A cache entry evicted event
class CacheEntryEvictedEvent<T> extends CacheEntryRemovedEvent<T> {
  /// Builds a [CacheEntryEvictedEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The evicted entry
  CacheEntryEvictedEvent(super.source, super.entry)
      : super(type: CacheEventType.evicted);
}
