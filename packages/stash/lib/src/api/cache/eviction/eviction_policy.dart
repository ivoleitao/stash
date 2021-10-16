import 'package:stash/src/api/cache/cache_info.dart';

/// Defines the eviction policy contract that every cache eviction algorithm should implement
abstract class EvictionPolicy {
  /// Builds a [EvictionPolicy]
  const EvictionPolicy();

  /// Finds the best eviction candidate based on the sampled entries. What
  /// distinguishes this approach from the classic data structures approach is
  /// that an [CacheInfo] contains metadata (e.g. usage information) which can be used
  /// for making policy decisions, while generic data structures do not. It is
  /// expected that implementations will take advantage of that metadata.
  ///
  /// * [entries]: A list of non nullable sample entries to consider
  /// * [justAdded]: The entry added, provided so that it can be ignored if selected.
  ///
  /// Returns the [CacheInfo] of the entry that should be evicted or null if the
  /// entry list is empty
  CacheInfo? select(Iterable<CacheInfo?> entries, CacheInfo justAdded);
}
