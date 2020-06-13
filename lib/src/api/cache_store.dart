import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_stat.dart';

/// The definition of a cache store
abstract class CacheStore {
  /// The number of entries in the store for the named cache
  ///
  /// * [name]: The cache name
  Future<int> size(String name);

  /// Returns a [Iterable] over all the [CacheStore] keys for the named cache
  ///
  /// * [name]: The cache name
  Future<Iterable<String>> keys(String name);

  /// Returns a [Iterable] over all the [CacheStore] [CacheStat]s for a named cache. It provides
  /// a optimized retrieval strategy that avoids reading the [CacheEntry] implementation into memory
  ///
  /// * [name]: The cache name
  Future<Iterable<CacheStat>> stats(String name);

  /// Returns a [Iterable] over all the [CacheStore] [CacheStat]s keys requested of a named cache. It provides
  /// a optimized retrieval strategy that avoids reading the [CacheEntry] implementation into memory
  ///
  /// * [name]: The cache name
  /// * [keys]: The list of keys
  Future<Iterable<CacheStat>> getStats(String name, Iterable<String> keys);

  /// Returns a [Iterable] over all the [CacheStore] [CacheEntry]s of a named cache.
  ///
  /// * [name]: The cache name
  Future<Iterable<CacheEntry>> values(String name);

  /// Checks if the named cache store contains a value indexed by [key]
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  Future<bool> containsKey(String name, String key);

  /// Returns the [CacheStat] for the specified cache [key]. It provides
  /// an optimized retrieval strategy that avoids reading the [CacheEntry] implementation into memory
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  Future<CacheStat> getStat(String name, String key);

  /// Sets the named cache [CacheStat] [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  /// * [stat]: The cache stat
  Future<void> setStat(String name, String key, CacheStat stat);

  /// Returns the [CacheEntry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  Future<CacheEntry> getEntry(String name, String key);

  /// Puts a cache entry identified by [key] on the named cache [CacheStore]. The value is overriden if already exists or
  /// added if it does not exists.
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  /// * [entry]: The cache entry
  Future<void> putEntry(String name, String key, CacheEntry entry);

  /// Removes the stored [CacheEntry] for the specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  Future<void> remove(String name, String key);

  /// Clears a named cache store
  ///
  /// * [name]: The cache name
  Future<void> clear(String name);

  /// Deletes a named cache from a store
  ///
  /// * [name]: The cache name
  Future<void> delete(String name);

  /// Deletes all caches from the store
  Future<void> deleteAll();
}
