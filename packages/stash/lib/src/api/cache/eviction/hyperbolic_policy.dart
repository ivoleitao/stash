import 'package:stash/src/api/cache/cache_info.dart';

import 'base_policy.dart';

/// Discards based on how frequently the entries are used divided by their age.
class HyperbolicEvictionPolicy extends BaseEvictionPolicy {
  /// Builds a [HyperbolicEvictionPolicy]
  const HyperbolicEvictionPolicy();

  @override
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now) {
    int entryTicks = (now.microsecond - entry.creationTime.microsecond);
    int selectedEntryTicks =
        (now.microsecond - selectedEntry.creationTime.microsecond);
    if (entryTicks > 0 && selectedEntryTicks > 0) {
      double entryFactor =
          entry.hitCount / (now.microsecond - entry.creationTime.microsecond);
      double selectedEntryTicks = selectedEntry.hitCount /
          (now.microsecond - selectedEntry.creationTime.microsecond);
      return entryFactor < selectedEntryTicks;
    }

    return false;
  }
}
