import 'package:stash/stash_api.dart';

/// In-memory [Map] backed implementation of a [CacheStore]
class MemoryStore extends CacheStore {
  /// In-memory [Map] to stores multiple caches.
  /// The value is [Map] of key/[CacheEntry]
  final Map<String, Map<String, CacheEntry>> _store =
      <String, Map<String, CacheEntry>>{};

  /// Returns a specific cache identified by [name] or a empty [Map] of key/[CacheEntry]
  Map<String, CacheEntry> _cacheStore(String name) =>
      _store[name] ?? const <String, CacheEntry>{};

  @override
  Future<int> size(String name) => Future.value(_cacheStore(name).length);

  @override
  Future<Iterable<String>> keys(String name) =>
      Future.value(_cacheStore(name).keys);

  @override
  Future<Iterable<CacheStat>> stats(String name) =>
      Future.value(_cacheStore(name).values.map((value) => value.stat));

  @override
  Future<Iterable<CacheEntry>> values(String name) =>
      Future.value(_cacheStore(name).values);

  @override
  Future<bool> containsKey(String name, String key) {
    return Future.value(_cacheStore(name).containsKey(key));
  }

  @override
  Future<CacheStat> getStat(String name, String key) {
    return Future.value(_cacheStore(name)[key]);
  }

  @override
  Future<Iterable<CacheStat>> getStats(String name, Iterable<String> keys) {
    return Future.value(keys.map((key) => _cacheStore(name)[key]));
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    _store[name][key].stat = stat;
    return Future.value();
  }

  @override
  Future<CacheEntry> getEntry(String name, String key) {
    return Future.value(_cacheStore(name)[key]);
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    if (!_store.containsKey(name)) {
      _store[name] = {};
    }

    _cacheStore(name)[key] = entry;

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    _cacheStore(name).remove(key);
    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    _cacheStore(name).clear();
    return Future.value();
  }

  @override
  Future<void> delete(String name) {
    _store.remove(name);
    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    _store.clear();
    return Future.value();
  }
}
