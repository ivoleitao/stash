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
  CacheEntry._(super.info, super.value, super.state);

  /// Builds a new [CacheEntry]
  ///
  /// * [builder]: The [CacheEntry] builder
  CacheEntry._builder(CacheEntryBuilder builder)
      : this._(
            CacheInfo(builder.key, builder.creationTime,
                builder.creationTime.add(builder.expiryDuration),
                hitCount: builder.hitCount,
                accessTime: builder.accessTime,
                updateTime: builder.updateTime),
            builder.value,
            builder.state);

  /// Creates a loaded [CacheEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry.loaded(
      String key, DateTime creationTime, DateTime expiryTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : this._(
            CacheInfo(key, creationTime, expiryTime,
                hitCount: hitCount,
                accessTime: accessTime,
                updateTime: updateTime),
            value,
            EntryState.loaded);

  /// Creates an updated [CacheEntry]
  ///
  /// * [info]: The cache info of the original entry
  /// * [value]: The cache value
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  /// * [expiryTime]: The cache expiry time
  CacheEntry.updated(
      CacheInfo info, dynamic value, DateTime updateTime, int hitCount,
      {DateTime? expiryTime})
      : this._(
            CacheInfo(
                info.key, info.creationTime, expiryTime ?? info.expiryTime,
                hitCount: hitCount,
                accessTime: info.accessTime,
                updateTime: updateTime),
            value,
            EntryState.updated);

  /// Updates the [Info] fields
  ///
  /// * [expiryTime]: The cache expiry time
  /// * [hitCount]: The cache hit count
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  @override
  void updateInfoFields({
    DateTime? expiryTime,
    int? hitCount,
    DateTime? accessTime,
    DateTime? updateTime,
  }) {
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
      hitCount: info.hitCount,
      expiryTime: info.expiryTime,
      accessTime: info.accessTime,
      updateTime: info.updateTime,
    );
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

/// The [CacheEntry] builder
class CacheEntryBuilder<T> extends EntryBuilder<T, CacheInfo, CacheEntry> {
  /// The expiry duration
  Duration expiryDuration;

  // The hit count
  int? hitCount;

  /// Builds a [CacheEntryBuilder]
  ///
  /// * [key]: The entry key
  /// * [value]: The entry value
  /// * [creationTime]: The entry creation time
  /// * [expiryDuration]: The entry expiry duration
  /// * [hitCount]: The entry hit count
  /// * [accessTime]: The access time
  /// * [updateTime]: The update time
  CacheEntryBuilder(
      super.key, super.value, super.creationTime, this.expiryDuration,
      {this.hitCount, super.accessTime, super.updateTime});

  @override
  CacheEntry build() {
    return CacheEntry._builder(this);
  }
}
