import 'package:stash/src/api/cache/cache_info.dart';

import 'base_policy.dart';

/// Counts how often an item is needed. Those that are used most often are discarded first.
/// This works very similar to MRU except that instead of storing the value of how recently a block was accessed,
/// we store the value of how many times it was accessed. So of course while running an access sequence we will
/// replace a entry which was used most number of times from our cache. E.g., if A was used (accessed) 5 times
/// and B was used 3 times and C was used 10 times, we will replace C. This algorithm uses
/// the [CacheInfo.hitCount] to keep track of how many times a entry was uses.
class MfuEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [MfuEvictionPolicy]
  const MfuEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    return entry.hitCount > selectedEntry.hitCount;
  }
}
