import 'package:stash/src/api/cache_stat.dart';

/// Defines the eviction policy contract that every cache eviction algorithm should implement
abstract class EvictionPolicy {
  /// Builds a [EvictionPolicy]
  const EvictionPolicy();

  /// Finds the best eviction candidate based on the sampled entries. What
  /// distinguishes this approach from the classic data structures approach is
  /// that an [CacheStat] contains metadata (e.g. usage statistics) which can be used
  /// for making policy decisions, while generic data structures do not. It is
  /// expected that implementations will take advantage of that metadata.
  ///
  /// * [entries]: A list of non nullable sample entries to consider
  /// * [justAdded]: The entry added, provided so that it can be ignored if selected.
  ///
  /// Returns the [CacheStat] of the entry that should be evicted or null if the
  /// entry list is empty
  CacheStat? select(Iterable<CacheStat?> entries, CacheStat justAdded);
}
