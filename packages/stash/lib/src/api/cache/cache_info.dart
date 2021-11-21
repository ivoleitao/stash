import 'package:stash/src/api/info.dart';

/// Base class with all the info fields for the Cache
class CacheInfo extends Info {
  /// Cache expiration time
  DateTime expiryTime;

  /// Cache hitcount
  int hitCount;

  /// Builds a [CacheInfo]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheInfo(String key, DateTime creationTime, this.expiryTime,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : assert(hitCount == null || hitCount >= 0),
        hitCount = hitCount ?? 0,
        super(key, creationTime,
            accessTime: accessTime, updateTime: updateTime);

  /// Checks if the cache info is expired
  ///
  /// * [now]: An optional value for the current time
  ///
  /// Return true if expired, false if not
  bool isExpired([DateTime? now]) {
    return expiryTime.isBefore(now ?? DateTime.now());
  }

  @override
  List<Object?> get props => [...super.props, expiryTime, hitCount];
}
