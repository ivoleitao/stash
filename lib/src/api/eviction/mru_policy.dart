import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';

/// Discards, in contrast to LRU, the most recently used items first. This algorithm uses the [CacheStat.accessTime]
/// to keep track of what was used when.
class MruEvictionPolicy extends EvictionPolicy {
  /// Builds a [MruEvictionPolicy]
  const MruEvictionPolicy();

  @override
  CacheStat select(Iterable<CacheStat> entries, CacheStat justAdded) {
    var selectedEntry;
    for (var entry in entries) {
      if (entry != null &&
          (selectedEntry == null ||
              entry.accessTime.isAfter(selectedEntry.accessTime)) &&
          justAdded.key != entry.key) {
        selectedEntry = entry;
      }
    }

    return selectedEntry;
  }
}
