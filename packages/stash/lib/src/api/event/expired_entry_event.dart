import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/event/entry_event.dart';

/// A Cache entry expired event
class ExpiredEntryEvent extends CacheEntryEvent {
  /// The expired entry
  final CacheEntry entry;

  /// Builds a [ExpiredEntryEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [entry]: The expired entry
  ExpiredEntryEvent(Cache source, this.entry)
      : super(source, EntryEventType.EXPIRED);
}
