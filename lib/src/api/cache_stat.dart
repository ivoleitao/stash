import 'package:equatable/equatable.dart';

/// Base class with all the stat fields backing up cache expiration and eviction strategies
class CacheStat with EquatableMixin {
  /// The cache key
  final String key;

  /// Cache expiration time
  DateTime expiryTime;

  /// Cache creation time
  final DateTime creationTime;

  /// Cache access time
  DateTime accessTime;

  /// Cache update time
  DateTime updateTime;

  /// Cache hitcount
  int hitCount;

  /// Builds a [CacheStat]
  ///
  /// * [key]: The cache key
  /// * [expiryTime]: The cache expiry time
  /// * [creationTime]: The cache creation time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheStat(this.key, this.expiryTime,
      {DateTime creationTime,
      DateTime accessTime,
      DateTime updateTime,
      int hitCount})
      : assert(key != null && key.isNotEmpty),
        assert(expiryTime != null),
        creationTime = creationTime ?? DateTime.now(),
        assert(hitCount == null || hitCount >= 0),
        hitCount = hitCount ?? 0 {
    this.accessTime = accessTime ?? this.creationTime;
    this.updateTime = updateTime ?? this.creationTime;
  }

  /// Checks if the cache entry is expired
  ///
  /// * [now]: An optional value for the current time
  ///
  /// Return true if expired, false if not
  bool isExpired([DateTime now]) {
    return expiryTime != null && expiryTime.isBefore(now ?? DateTime.now());
  }

  @override
  List<Object> get props =>
      [key, expiryTime, creationTime, accessTime, updateTime, hitCount];
}
