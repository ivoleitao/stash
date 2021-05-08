import 'package:objectdb/objectdb.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/stash_api.dart';

/// Objectdb based implemention of a [CacheStore]
class ObjectDBStore extends CacheStore {
  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// List of stored per cache name
  final Map<String, StorageInterface> _cacheStoreMap = {};

  /// Builds a [ObjectDBStore].
  ///
  /// * [_storageBuilder]: The function that creates instances of the storage
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  ObjectDBStore({dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  /// Returns the cache [StorageInterface] or opens a new store it under the base path
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [StorageInterface] of the cache
  Future<StorageInterface> _cacheStore(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      return Future.value(_cacheStoreMap[name]);
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<bool> containsKey(String name, String key) {
    // TODO: implement containsKey
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String name) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    // TODO: implement getEntry
    throw UnimplementedError();
  }

  @override
  Future<CacheStat?> getStat(String name, String key) {
    // TODO: implement getStat
    throw UnimplementedError();
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) {
    // TODO: implement getStats
    throw UnimplementedError();
  }

  @override
  Future<Iterable<String>> keys(String name) {
    // TODO: implement keys
    throw UnimplementedError();
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    // TODO: implement putEntry
    throw UnimplementedError();
  }

  @override
  Future<void> remove(String name, String key) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    // TODO: implement setStat
    throw UnimplementedError();
  }

  @override
  Future<int> size(String name) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Future<Iterable<CacheStat>> stats(String name) {
    // TODO: implement stats
    throw UnimplementedError();
  }

  @override
  Future<Iterable<CacheEntry>> values(String name) {
    // TODO: implement values
    throw UnimplementedError();
  }
}
