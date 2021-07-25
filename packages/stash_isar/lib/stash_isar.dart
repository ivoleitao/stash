/// Provides a Isar implementation of the Stash caching API for Dart
library stash_isar;

import 'package:stash/stash_api.dart';
import 'package:stash_isar/src/isar/isar_store.dart';

export 'src/isar/isar_store.dart';

/// Creates a new [Cache] backed by a [IsarStore]
///
/// * [store]: An existing isar store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache _newIsarCache(IsarStore store,
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode}) {
  return Cache.newCache(store,
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [IsarStore]
///
/// * [path]: The base storage location for this store
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
IsarStore newIsarStore(
    {String? path, dynamic Function(dynamic)? fromEncodable}) {
  return IsarStore(fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a [IsarStore]
///
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [fromEncodable] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [IsarStore]
Cache newIsarCache(
    {String? path,
    String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    CacheStore? store,
    dynamic Function(dynamic)? fromEncodable}) {
  return _newIsarCache(newIsarStore(path: path, fromEncodable: fromEncodable),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [IsarStore] allowing the creation of multiple caches from
/// the same store
extension IsarStoreExtension on IsarStore {
  Cache cache(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newIsarCache(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
