import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

/// A Cache entry created event
class CreatedEntryEvent extends CacheEntryEvent {
  /// The created entry
  final CacheEntry entry;

  /// Builds a [CreatedEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The created entry
  CreatedEntryEvent(Cache source, this.entry)
      : super(source, EntryEventType.CREATED);
}
