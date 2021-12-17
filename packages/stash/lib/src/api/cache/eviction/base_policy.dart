import 'package:meta/meta.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';

import '../cache_info.dart';

/// Base implementation of a eviction policy
abstract class BaseEvictionPolicy implements EvictionPolicy {
  /// Builds a [BaseEvictionPolicy]
  const BaseEvictionPolicy();

  /// Returns `true` if [entry] is a better candidate for eviction than the
  /// current [selectedEntry]
  ///
  /// * [entry]: The current entry
  /// * [selectedEntry]: The current selected entry
  /// * [now]: The current time
  @protected
  bool selectEntry(CacheInfo entry, CacheInfo selectedEntry, DateTime now);

  @override
  CacheInfo? select(Iterable<CacheInfo?> entries, DateTime now) {
    CacheInfo? selectedEntry;
    for (var entry in entries) {
      if (entry != null) {
        // Prefer the expired entries
        if (entry.isExpired(now)) {
          return entry;
        }
        if (selectedEntry == null || selectEntry(entry, selectedEntry, now)) {
          selectedEntry = entry;
        }
      }
    }

    return selectedEntry;
  }
}
