import 'package:hive/hive.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/src/hive/hive_extensions.dart';

/// Hive based implemention of a [CacheStore]
class HiveStore extends CacheStore {
  /// The base location of the Hive Box
  final String _path;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// List of boxes per cache name
  final Map<String, LazyBox<Map>> _cacheStoreMap = {};

  /// Builds a [HiveStore].
  ///
  /// * [_path]: The base location of the Hive storage
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveStore(this._path, {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  /// Returns the [LazyBox] where a cache is stored or opens a new box it under the base path
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [LazyBox] where the cache is stored
  Future<LazyBox<Map>> _cacheStore(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      return Future.value(_cacheStoreMap[name]);
    }

    return Hive.openLazyBox<Map>(name, path: _path).then((store) {
      _cacheStoreMap[name] = store;

      return store;
    });
  }

  @override
  Future<int> size(String name) =>
      _cacheStore(name).then((store) => store.length);

  Future<Iterable<String>> _getKeys(String name) {
    return _cacheStore(name).then((store) => store.keys.cast<String>());
  }

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  /// Gets a [CacheEntry] from the provided [LazyBox]
  ///
  /// * [store]: The Hive box
  /// * [key]: The cache key
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntryFromStore(LazyBox<Map> store, String key) =>
      store.get(key).then((value) => value != null
          ? HiveExtensions.fromJson(value.cast<String, dynamic>(),
              fromJson: _fromEncodable)
          : null);

  /// Returns the [CacheEntry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntry(String name, String key) {
    return _cacheStore(name).then((store) => _getEntryFromStore(store, key));
  }

  /// Returns the [CacheStat] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [CacheStat]
  Future<CacheStat?> _getStat(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.stat);
  }

  /// Returns a [Iterable] over all the [CacheStore] [CacheStat]s keys requested
  /// of a named cache.
  ///
  /// * [name]: The cache name
  /// * [keys]: The list of keys
  ///
  /// Return a list of [CacheStat]s
  Future<Iterable<CacheStat?>> _getStats(String name, Iterable<String> keys) {
    return Stream.fromIterable(keys)
        .asyncMap((key) => _getStat(name, key))
        .toList();
  }

  @override
  Future<Iterable<CacheStat>> stats(String name) => _getKeys(name)
      .then((keys) => _getStats(name, keys))
      .then((stats) => stats.map((stat) => stat!));

  /// Returns a [Iterable] over all the [CacheStore] [CacheEntry]s
  /// of a named cache.
  ///
  /// * [name]: The cache name
  ///
  /// Return a list of [CacheEntry]s
  Future<Iterable<CacheEntry>> _getValues(String name) {
    return _getKeys(name).then((keys) => Stream.fromIterable(keys)
        .asyncMap((key) => _getEntry(name, key))
        .map((stat) => stat!)
        .toList());
  }

  @override
  Future<Iterable<CacheEntry>> values(String name) => _getValues(name);

  @override
  Future<bool> containsKey(String name, String key) =>
      _cacheStore(name).then((store) => store.containsKey(key));

  @override
  Future<CacheStat?> getStat(String name, String key) {
    return _getStat(name, key);
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) {
    return _getStats(name, keys);
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _cacheStore(name).then((store) {
      return _getEntryFromStore(store, key)
          .then((entry) => store.put(key, (entry!..stat = stat).toHiveJson()));
    });
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    return _cacheStore(name)
        .then((store) => store.put(key, entry.toHiveJson()));
  }

  @override
  Future<void> remove(String name, String key) {
    return _cacheStore(name).then((store) => store.delete(key));
  }

  @override
  Future<void> clear(String name) {
    return _cacheStore(name).then((store) => store.clear());
  }

  @override
  Future<void> delete(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      _cacheStoreMap.remove(name);
      return Hive.deleteBoxFromDisk(name);
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheStoreMap.keys.map((name) {
      return Hive.deleteBoxFromDisk(name)
          .then((_) => _cacheStoreMap.remove(name));
    }));
  }
}
