import 'package:stash/src/api/entry.dart';

import 'cache_info.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends Entry<CacheInfo> {
  /// The expiry time getter
  DateTime get expiryTime => info.expiryTime;

  /// The hit count getter
  int get hitCount => info.hitCount;

  /// Creates a [CacheEntry]
  ///
  /// * [info]: The cache info
  /// * [value]: The cache value
  /// * [state]: The entry state
  CacheEntry._(CacheInfo info, dynamic value, EntryState state)
      : super(info, value, state);

  /// Creates a new [CacheEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [value]: The cache value
  CacheEntry.addEntry(
      String key, DateTime creationTime, DateTime expiryTime, dynamic value)
      : this._(
            CacheInfo(key, creationTime, expiryTime), value, EntryState.added);

  /// Creates a new [CacheEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry.loadEntry(
      String key, DateTime creationTime, DateTime expiryTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : this._(
            CacheInfo(key, creationTime, expiryTime,
                accessTime: accessTime,
                updateTime: updateTime,
                hitCount: hitCount),
            value,
            EntryState.loaded);

  /// Copy the current [CacheEntry] and updates it
  ///
  /// * [value]: The cache value
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  /// * [expiryTime]: The cache expiry time
  CacheEntry updateValue(dynamic value, DateTime updateTime, int hitCount,
      {DateTime? expiryTime}) {
    return CacheEntry._(
        CacheInfo(key, creationTime, expiryTime ?? this.expiryTime,
            accessTime: accessTime, updateTime: updateTime, hitCount: hitCount),
        value,
        EntryState.updatedValue);
  }

  /// Updates the [Info] fields
  ///
  /// * [expiryTime]: The cache expiry time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  @override
  void updateInfoFields(
      {DateTime? expiryTime,
      DateTime? accessTime,
      DateTime? updateTime,
      int? hitCount}) {
    super.updateInfoFields(accessTime: accessTime, updateTime: updateTime);
    info.expiryTime = expiryTime ?? info.expiryTime;
    info.hitCount = hitCount ?? info.hitCount;
  }

  /// Updates a [CacheEntry] info
  ///
  /// * [info]: The updated info
  @override
  void updateInfo(CacheInfo info) {
    updateInfoFields(
        expiryTime: info.expiryTime,
        accessTime: info.accessTime,
        updateTime: info.updateTime,
        hitCount: info.hitCount);
  }

  /// Checks if the cache entry is expired
  ///
  /// * [now]: An optional value for the current time
  ///
  /// Return true if expired, false if not
  bool isExpired([DateTime? now]) {
    return info.isExpired(now);
  }
}
