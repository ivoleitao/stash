import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';

/// This algorithm the cache behaves in the same way as a stack and exact opposite way as a FIFO queue.
/// The cache evicts the entry added most recently first without any regard to how often or how many times
/// it was accessed before.  This algorithm uses [CacheStat.creationTime] to keep track of when a entry was created.
class FiloEvictionPolicy extends EvictionPolicy {
  /// Builds a [FiloEvictionPolicy]
  const FiloEvictionPolicy();

  @override
  CacheStat select(Iterable<CacheStat> entries, CacheStat justAdded) {
    var selectedEntry;
    for (var entry in entries) {
      if (entry != null &&
          (selectedEntry == null ||
              entry.creationTime.isAfter(selectedEntry.creationTime)) &&
          justAdded.key != entry.key) {
        selectedEntry = entry;
      }
    }

    return selectedEntry;
  }
}
