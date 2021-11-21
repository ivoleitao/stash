import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/eviction/base_policy.dart';

/// Using this algorithm the cache behaves in the same way as a FIFO queue.
/// The cache evicts the sampled entries in the order they were added, without any
/// regard to how often or how many times they were accessed before. This algorithm uses
/// [CacheInfo.creationTime] to keep track of when a entry was created.
class FifoEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [FifoEvictionPolicy]
  const FifoEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    return entry.creationTime.isBefore(selectedEntry.creationTime);
  }
}
