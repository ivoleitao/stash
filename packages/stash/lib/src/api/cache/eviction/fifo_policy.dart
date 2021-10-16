import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';

/// Using this algorithm the cache behaves in the same way as a FIFO queue.
/// The cache evicts the sampled entries in the order they were added, without any
/// regard to how often or how many times they were accessed before. This algorithm uses
/// [CacheInfo.creationTime] to keep track of when a entry was created.
class FifoEvictionPolicy implements EvictionPolicy {
  /// Builds a [FifoEvictionPolicy]
  const FifoEvictionPolicy();

  @override
  CacheInfo? select(Iterable<CacheInfo?> entries, CacheInfo justAdded) {
    CacheInfo? selectedEntry;
    for (var entry in entries) {
      if (entry != null &&
          (selectedEntry == null ||
              entry.creationTime.isBefore(selectedEntry.creationTime)) &&
          justAdded.key != entry.key) {
        selectedEntry = entry;
      }
    }

    return selectedEntry;
  }
}
