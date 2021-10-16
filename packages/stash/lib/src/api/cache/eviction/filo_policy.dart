import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';

/// This algorithm the cache behaves in the same way as a stack and exact opposite way as a FIFO queue.
/// The cache evicts the entry added most recently first without any regard to how often or how many times
/// it was accessed before.  This algorithm uses [CacheInfo.creationTime] to keep track of when a entry was created.
class FiloEvictionPolicy implements EvictionPolicy {
  /// Builds a [FiloEvictionPolicy]
  const FiloEvictionPolicy();

  @override
  CacheInfo? select(Iterable<CacheInfo?> entries, CacheInfo justAdded) {
    CacheInfo? selectedEntry;
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
