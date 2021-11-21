import 'package:stash/src/api/cache/cache_info.dart';

import 'base_policy.dart';

/// Discards the least recently used items first. This algorithm uses the [CacheInfo.accessTime]
/// to keep track of what was used when.
class LruEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [LruEvictionPolicy]
  const LruEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    return entry.accessTime.isBefore(selectedEntry.accessTime);
  }
}
