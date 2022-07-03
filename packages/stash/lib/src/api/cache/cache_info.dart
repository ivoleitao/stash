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
  /// * [hitCount]: The cache hit count
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  CacheInfo(super.key, super.creationTime, this.expiryTime,
      {int? hitCount, super.accessTime, super.updateTime})
      : assert(hitCount == null || hitCount >= 0),
        hitCount = hitCount ?? 0;

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
