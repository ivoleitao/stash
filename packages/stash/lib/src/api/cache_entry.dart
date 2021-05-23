import 'package:stash/src/api/cache_stat.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends CacheStat {
  /// The value stored in the cache
  dynamic _value;

  /// Tracks any changes to the [CacheEntry] after obtaining it from the store
  bool? _valueChanged;

  CacheEntry._(String key, dynamic value, DateTime expiryTime,
      DateTime creationTime, this._valueChanged,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : _value = value,
        super(key, expiryTime, creationTime,
            accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);

  CacheEntry(
      String key, dynamic value, DateTime expiryTime, DateTime creationTime,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : this._(key, value, expiryTime, creationTime, null,
            accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);

  /// Returns the stored value
  dynamic get value => _value;

  /// Returns true if the value was changed after retrieval from the store or if it was newly created
  bool get valueChanged => _valueChanged ?? true;

  /// Returns a [CacheStat] from this [CacheEntry]
  CacheStat get stat => CacheStat(key, expiryTime, creationTime)
    ..accessTime = accessTime
    ..updateTime = updateTime
    ..hitCount = hitCount;

  /// Sets the [CacheStat] part of this [CacheEntry]
  ///
  /// * [stat]: The new [CacheStat]
  set stat(CacheStat stat) {
    expiryTime = stat.expiryTime;
    accessTime = stat.accessTime;
    updateTime = stat.updateTime;
    hitCount = stat.hitCount;
  }

  /// Copies a [CacheEntry]
  ///
  /// * [value]: The value
  /// * [key]: The cache key
  /// * [expiryTime]: The cache expiry time
  /// * [creationTime]: The cache creation time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry copyForUpdate(dynamic value,
          {String? key,
          DateTime? expiryTime,
          DateTime? creationTime,
          DateTime? accessTime,
          DateTime? updateTime,
          int? hitCount}) =>
      CacheEntry._(
        key ?? this.key,
        value,
        expiryTime ?? this.expiryTime,
        creationTime ?? this.creationTime,
        true,
        accessTime: accessTime ?? this.accessTime,
        updateTime: updateTime ?? this.updateTime,
        hitCount: hitCount ?? this.hitCount,
      );

  @override
  List<Object?> get props => [...super.props, value];
}
