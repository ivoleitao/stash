import 'cache_stat.dart';
import 'entry.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends Entry<CacheStat> {
  /// The expiry time getter
  DateTime get expiryTime => stat.expiryTime;

  /// The expiry time setter
  ///
  /// * [expiryTime]: The expiry time
  set expiryTime(DateTime expiryTime) {
    stat.expiryTime = expiryTime;
  }

  /// The hit count getter
  int get hitCount => stat.hitCount;

  /// The hit count setter
  ///
  /// * [hitCount]: The hit count
  set hitCount(int hitCount) {
    stat.hitCount = hitCount;
  }

  /// Creates a [CacheEntry]
  ///
  /// * [stat]: The cache stat
  /// * [value]: The cache value
  /// * [valueChanged]: If this value was changed
  CacheEntry._(CacheStat stat, dynamic value, bool? valueChanged)
      : super(stat, value, valueChanged);

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
            CacheStat(key, creationTime, expiryTime,
                accessTime: accessTime,
                updateTime: updateTime,
                hitCount: hitCount),
            value,
            null);

  /// Updates a [CacheEntry] stat
  ///
  /// * [stat]: The updated stat
  @override
  void updateStat(CacheStat stat) {
    super.updateStat(stat);
    this.stat.expiryTime = stat.expiryTime;
    this.stat.hitCount = stat.hitCount;
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
          CacheStat(key, creationTime, expiryTime ?? this.expiryTime,
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
    return stat.expiryTime.isBefore(now ?? DateTime.now());
  }
}
