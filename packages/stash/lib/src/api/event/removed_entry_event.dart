import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

/// A Cache entry removed event
class RemovedEntryEvent extends CacheEntryEvent {
  /// The removed entry
  final CacheEntry entry;

  /// Builds a [RemovedEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The removed entry
  /// * [type]: The event type
  RemovedEntryEvent(Cache source, this.entry, {EntryEventType? type})
      : super(source, type ?? EntryEventType.REMOVED);
}
