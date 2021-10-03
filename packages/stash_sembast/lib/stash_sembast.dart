/// Provides a Sembast implementation of the Stash caching API for Dart
library stash_sembast;

import 'package:sembast/sembast.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_adapter.dart';
import 'package:stash_sembast/src/sembast/sembast_store.dart';

export 'src/sembast/sembast_adapter.dart';
export 'src/sembast/sembast_store.dart';

/// Creates a new [Cache] backed by a [SembastCacheStore]
///
/// * [store]: An existing sembast store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> newSembastCache<T>(SembastCacheStore store,
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode}) {
  return Cache<T>.newCache(store,
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [SembastCacheStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
SembastCacheStore newSembastFileCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastCacheStore(
      SembastPathAdapter(path ?? 'stash_sembast.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a [SembastCacheStore]
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [fromEncodable], [databaseVersion], [onVersionChanged], [databaseMode] and  [sembastCodec] will be all ignored is this parameter is provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
///
/// Returns a new [Cache] backed by a [SembastStore]
Cache<T> newSembastFileCache<T>(
    {String? path,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SembastCacheStore? store,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return newSembastCache<T>(
      newSembastFileCacheStore(
          path: path,
          fromEncodable: fromEncodable,
          databaseVersion: databaseVersion,
          onVersionChanged: onVersionChanged,
          databaseMode: databaseMode,
          sembastCodec: sembastCodec),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new in-memory [SembastStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
SembastCacheStore newSembastMemoryCacheStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastCacheStore(
      SembastMemoryAdapter('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a in-memory [SembastCacheStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [fromEncodable], [databaseVersion], [onVersionChanged], [databaseMode] and  [sembastCodec] will be all ignored is this parameter is provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
///
/// Returns a new [Cache] backed by a [SembastStore]
Cache<T> newSembastMemoryCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SembastCacheStore? store,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return newSembastCache<T>(
      newSembastMemoryCacheStore(
          fromEncodable: fromEncodable,
          databaseVersion: databaseVersion,
          onVersionChanged: onVersionChanged,
          databaseMode: databaseMode,
          sembastCodec: sembastCodec),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [SembastCacheStore] allowing the creation of multiple caches from
/// the same store
extension SembastStoreExtension on SembastCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return newSembastCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
