import 'package:stash/src/api/entry.dart';

import 'cache_info.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends Entry<CacheInfo> {
  /// The expiry time getter
  DateTime get expiryTime => info.expiryTime;

  /// The expiry time setter
  ///
  /// * [expiryTime]: The expiry time
  set expiryTime(DateTime expiryTime) {
    info.expiryTime = expiryTime;
  }

  /// The hit count getter
  int get hitCount => info.hitCount;

  /// The hit count setter
  ///
  /// * [hitCount]: The hit count
  set hitCount(int hitCount) {
    info.hitCount = hitCount;
  }

  /// Creates a [CacheEntry]
  ///
  /// * [info]: The cache info
  /// * [value]: The cache value
  /// * [valueChanged]: If this value was changed
  CacheEntry._(CacheInfo info, dynamic value, bool? valueChanged)
      : super(info, value, valueChanged);

  /// Creates a new [CacheEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry.newEntry(
      String key, DateTime creationTime, DateTime expiryTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : this._(
            CacheInfo(key, creationTime, expiryTime,
                accessTime: accessTime,
                updateTime: updateTime,
                hitCount: hitCount),
            value,
            null);

  /// Updates a [CacheEntry] info
  ///
  /// * [info]: The updated info
  @override
  void updateInfo(CacheInfo info) {
    super.updateInfo(info);
    this.info.expiryTime = info.expiryTime;
    this.info.hitCount = info.hitCount;
  }

  /// Updates a [CacheEntry]
  ///
  /// * [value]: The value
  /// * [expiryTime]: The cache expiry time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry updateEntry(dynamic value,
          {DateTime? expiryTime,
          DateTime? accessTime,
          DateTime? updateTime,
          int? hitCount}) =>
      CacheEntry._(
          CacheInfo(key, creationTime, expiryTime ?? this.expiryTime,
              accessTime: accessTime,
              updateTime: updateTime ?? this.updateTime,
              hitCount: hitCount ?? this.hitCount),
          value,
          true);

  /// Checks if the cache entry is expired
  ///
  /// * [now]: An optional value for the current time
  ///
  /// Return true if expired, false if not
  bool isExpired([DateTime? now]) {
    return info.expiryTime.isBefore(now ?? DateTime.now());
  }
}
