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
/// * [path]: The base storage location for this cache
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Cache] backed by a [HiveDefaultStore]
Cache newHiveCache(String path,
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return Cache.newCache(
      HiveDefaultStore(
          HiveDefaultAdapter(path,
              encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
          fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [Cache] backed by a [HiveLazyStore]
///
/// * [path]: The base storage location for this cache
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Cache] backed by a [HiveLazyStore]
Cache newLazyHiveCache(String path,
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    dynamic Function(dynamic)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return Cache.newCache(
      HiveLazyStore(
          HiveLazyAdapter(path,
              encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
          fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}
