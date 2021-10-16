import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';

/// Discards the least recently used items first. This algorithm uses the [CacheInfo.accessTime]
/// to keep track of what was used when.
class LruEvictionPolicy implements EvictionPolicy {
  /// Builds a [LruEvictionPolicy]
  const LruEvictionPolicy();

  @override
  CacheInfo? select(Iterable<CacheInfo?> entries, CacheInfo justAdded) {
    CacheInfo? selectedEntry;
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
