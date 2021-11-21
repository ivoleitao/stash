import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/eviction/base_policy.dart';

/// This algorithm the cache behaves in the same way as a stack and exact opposite way as a FIFO queue.
/// The cache evicts the entry added most recently first without any regard to how often or how many times
/// it was accessed before.  This algorithm uses [CacheInfo.creationTime] to keep track of when a entry was created.
class FiloEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [FiloEvictionPolicy]
  const FiloEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    return entry.creationTime.isAfter(selectedEntry.creationTime);
  }
}
