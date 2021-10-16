import 'stash.dart';

// The event listener mode
enum EventListenerMode {
  // No events are published
  disabled,
  // Synchronous listener
  synchronous,
  // Asynchronous listener
  asynchronous
}

/// A stash event base class.
abstract class StashEvent<T, E extends Enum, S extends Stash<T>> {
  /// The stash that originated the event
  final S source;

  /// The type of this event
  final E type;

  /// Builds a [StashEvent]
  ///
  /// * [source]: The cache that originated the event
  /// * [type]: The event type
  StashEvent(this.source, this.type);
}
