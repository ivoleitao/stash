import 'package:stash/src/api/cache_stat.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends CacheStat {
  /// The value stored in the cache
  dynamic _value;

  /// Tracks any changes to the [CacheEntry] after obtaining it from the store
  bool _valueChanged;

  CacheEntry(String key, dynamic value, DateTime expiryTime,
      {DateTime creationTime,
      DateTime accessTime,
      DateTime updateTime,
      int hitCount})
      : _value = value,
        super(key, expiryTime,
            creationTime: creationTime,
            accessTime: accessTime,
            updateTime: updateTime,
            hitCount: hitCount);

  /// Returns the stored value
  dynamic get value => _value;

  /// Sets the stored value tracking the change
  ///
  /// * [value]: The new value
  set value(dynamic value) {
    _value = value;
    _valueChanged = true;
  }

  /// Returns true if the value was changed after retrievel from the store or if it was newly created
  bool get valueChanged => _valueChanged == null || _valueChanged;

  /// Returns a [CacheStat] from this [CacheEntry]
  CacheStat get stat => CacheStat(key, expiryTime, creationTime: creationTime)
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

  @override
  List<Object> get props => [...super.props, value];
}
