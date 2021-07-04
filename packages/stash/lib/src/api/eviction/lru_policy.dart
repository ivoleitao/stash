import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';

/// Discards the least recently used items first. This algorithm uses the [CacheStat.accessTime]
/// to keep track of what was used when.
class LruEvictionPolicy extends EvictionPolicy {
  /// Builds a [LruEvictionPolicy]
  const LruEvictionPolicy();

  @override
  CacheStat? select(Iterable<CacheStat?> entries, CacheStat justAdded) {
    CacheStat? selectedEntry;
    for (var entry in entries) {
      if (entry != null &&
          (selectedEntry == null ||
              entry.accessTime.isBefore(selectedEntry.accessTime)) &&
          justAdded.key != entry.key) {
        selectedEntry = entry;
      }
    }

    return selectedEntry;
  }
}
