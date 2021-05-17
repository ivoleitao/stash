import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/event/entry_event.dart';

/// A Cache entry removed event
class RemovedEntryEvent extends CacheEntryEvent {
  /// The removed key
  final String key;

  /// Builds a [RemovedEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [key]: The removed cache key
  RemovedEntryEvent(Cache source, this.key)
      : super(source, EntryEventType.REMOVED);
}
