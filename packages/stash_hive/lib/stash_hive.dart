/// Provides a Hive implementation of the Stash caching API for Dart
library stash_hive;

import 'package:hive/hive.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/src/hive/hive_adapter.dart';
import 'package:stash_hive/src/hive/hive_store.dart';

export 'src/hive/hive_adapter.dart';
export 'src/hive/hive_store.dart';

/// Creates a new [Cache] backed by a [HiveDefaultStore]
///
/// * [store]: An existing hive store
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newHiveCache<T>(HiveDefaultStore store,
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode}) {
  return Cache<T>.newCache(store,
      name: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [HiveDefaultStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveDefaultStore newHiveStore(
    {String? path,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultStore(
      HiveDefaultAdapter(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a [HiveDefaultStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [fromEncodable], [encryptionCipher] and [crashRecovery] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Cache] backed by a [HiveDefaultStore]
Cache<T> newHiveCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    HiveDefaultStore? store,
    String? path,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newHiveCache<T>(
      store ??
          newHiveStore(
              path: path,
              fromEncodable: fromEncodable,
              encryptionCipher: encryptionCipher,
              crashRecovery: crashRecovery),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      expiryPolicy: expiryPolicy,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [Cache] backed by a [HiveLazyStore]
///
/// * [store]: An existing hive store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newLazyHiveCache<T>(HiveLazyStore store,
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

/// Creates a new [HiveLazyStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveLazyStore newHiveLazyStore(
    {String? path,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyStore(
      HiveLazyAdapter(path ?? '.',
          encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a [HiveLazyStore]
///
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [fromEncodable], [encryptionCipher] and [crashRecovery] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Cache] backed by a [HiveLazyStore]
Cache newLazyHiveCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    HiveLazyStore? store,
    String? path,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newLazyHiveCache<T>(
      store ??
          newHiveLazyStore(
              path: path,
              fromEncodable: fromEncodable,
              encryptionCipher: encryptionCipher,
              crashRecovery: crashRecovery),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [HiveDefaultStore] allowing the creation of multiple caches from
/// the same store
extension HiveDefaultStoreExtension on HiveDefaultStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newHiveCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}

/// Extension over [HiveLazyStore] allowing the creation of multiple caches from
/// the same store
extension HiveLazyStoreExtension on HiveLazyStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newLazyHiveCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
