import 'package:stash/stash.dart';

/// Isar based implemention of a [CacheStore]
class IsarStore extends CacheStore {
  /// The function that converts between the Map representation to the
  /// object stored in the cache
  // final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [IsarStore].
  ///
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  IsarStore({dynamic Function(Map<String, dynamic>)? fromEncodable})
  /*: _fromEncodable = fromEncodable*/;

  @override
  Future<int> size(String name) => throw UnimplementedError();

  @override
  Future<Iterable<String>> keys(String name) => throw UnimplementedError();

  @override
  Future<Iterable<CacheStat>> stats(String name) => throw UnimplementedError();

  @override
  Future<Iterable<CacheEntry>> values(String name) =>
      throw UnimplementedError();

  @override
  Future<bool> containsKey(String name, String key) =>
      throw UnimplementedError();

  @override
  Future<CacheStat?> getStat(String name, String key) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) {
    throw UnimplementedError();
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    throw UnimplementedError();
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    throw UnimplementedError();
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    throw UnimplementedError();
  }

  @override
  Future<void> remove(String name, String key) {
    throw UnimplementedError();
  }

  @override
  Future<void> clear(String name) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String name) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll() {
    throw UnimplementedError();
  }
}
