import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';

/// Using this algorithm the cache behaves in the same way as a FIFO queue.
/// The cache evicts the sampled entries in the order they were added, without any
/// regard to how often or how many times they were accessed before. This algorithm uses
/// [CacheStat.creationTime] to keep track of when a entry was created.
class FifoEvictionPolicy extends EvictionPolicy {
  /// Builds a [FifoEvictionPolicy]
  const FifoEvictionPolicy();

  @override
  CacheStat select(Iterable<CacheStat> entries, CacheStat justAdded) {
    var selectedEntry;
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
