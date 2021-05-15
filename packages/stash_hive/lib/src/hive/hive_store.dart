import 'package:hive/hive.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/src/hive/hive_extensions.dart';

import 'hive_adapter.dart';

/// Hive based implemention of a [CacheStore]
abstract class HiveStore<T extends BoxBase<Map>> extends CacheStore {
  /// The adapter
  final HiveAdapter<T> _adapter;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [HiveStore].
  ///
  /// * [_adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveStore(this._adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  @override
  Future<int> size(String name) =>
      _adapter.store(name).then((store) => store.length);

  Future<Iterable<String>> _getKeys(String name) {
    return _adapter.store(name).then((store) => store.keys.cast<String>());
  }

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  /// Gets a [CacheEntry] from the provided [LazyBox]
  ///
  /// * [store]: The Hive box
  /// * [key]: The cache key
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntryFromStore(T store, String key) =>
      _adapter.boxValue(store, key).then((value) => value != null
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
    return _adapter.store(name).then((store) => _getEntryFromStore(store, key));
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
      _adapter.store(name).then((store) => store.containsKey(key));

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
    return _adapter.store(name).then((store) {
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
    return _adapter
        .store(name)
        .then((store) => store.put(key, entry.toHiveJson()));
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.store(name).then((store) => store.delete(key));
  }

  @override
  Future<void> clear(String name) {
    return _adapter.store(name).then((store) => store.clear());
  }

  @override
  Future<void> delete(String name) {
    return _adapter.delete(name);
  }

  @override
  Future<void> deleteAll() {
    return _adapter.deleteAll();
  }
}

class DefaultHiveStore extends HiveStore<Box<Map>> {
  /// Builds a [DefaultHiveStore].
  ///
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  DefaultHiveStore(DefaultHiveAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}

class LazyHiveStore extends HiveStore<LazyBox<Map>> {
  /// Builds a [LazyHiveStore].
  ///
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  LazyHiveStore(LazyHiveAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}
