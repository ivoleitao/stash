import 'package:stash/src/api/stat.dart';

/// Base class with all the stat fields for the Stash
class StashStat extends Stat {
  /// Builds a [StashStat]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  StashStat(String key, DateTime creationTime,
      {DateTime? accessTime, DateTime? updateTime})
      : super(key, creationTime,
            accessTime: accessTime, updateTime: updateTime);
}
