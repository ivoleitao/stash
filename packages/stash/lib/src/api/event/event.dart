import 'package:stash/src/api/cache.dart';

/// A Cache event base class.
abstract class CacheEvent {
  /// The cache that originated the event
  final Cache source;

  /// Builds a [CacheEvent]
  ///
  /// * [source]: The cache that originated the event
  CacheEvent(this.source);
}
