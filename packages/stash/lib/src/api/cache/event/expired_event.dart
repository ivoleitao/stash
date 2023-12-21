import 'event.dart';
import 'removed_event.dart';

/// A cache entry expired event
class CacheEntryExpiredEvent<T> extends CacheEntryRemovedEvent<T> {
  /// Builds a [CacheEntryExpiredEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The removed entry
  CacheEntryExpiredEvent(super.source, super.entry)
      : super(type: CacheEventType.expired);
}
