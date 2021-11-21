import 'package:stash/src/api/cache/cache_info.dart';

import 'base_policy.dart';

/// Discards, in contrast to LRU, the most recently used items first. This algorithm uses the [CacheInfo.accessTime]
/// to keep track of what was used when.
class MruEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [MruEvictionPolicy]
  const MruEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    return entry.accessTime.isAfter(selectedEntry.accessTime);
  }
}
