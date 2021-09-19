import 'package:stash/src/api/stat.dart';

/// Base class with all the stat fields for the Cache
class CacheStat extends Stat {
  /// Cache expiration time
  DateTime expiryTime;

  /// Cache hitcount
  int hitCount;

  /// Builds a [CacheStat]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheStat(String key, DateTime creationTime, this.expiryTime,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : assert(hitCount == null || hitCount >= 0),
        hitCount = hitCount ?? 0,
        super(key, creationTime,
            accessTime: accessTime, updateTime: updateTime);

  @override
  List<Object?> get props => [...super.props, expiryTime, hitCount];
}
