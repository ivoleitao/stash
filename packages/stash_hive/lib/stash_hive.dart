/// Provides a Hive implementation of the Stash caching API for Dart
library stash_hive;

import 'package:hive/hive.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/src/hive/hive_adapter.dart';
import 'package:stash_hive/src/hive/hive_store.dart';

export 'src/hive/hive_adapter.dart';
export 'src/hive/hive_store.dart';

/// Creates a new [HiveDefaultVaultStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveDefaultVaultStore newHiveDefaultVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultVaultStore(
      HiveDefaultAdapter(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveDefaultCacheStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveDefaultCacheStore newHiveDefaultCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultCacheStore(
      HiveDefaultAdapter(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveLazyVaultStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveLazyVaultStore newHiveLazyVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyVaultStore(
      HiveLazyAdapter(path ?? '.',
          encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveLazyCacheStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveLazyCacheStore newHiveLazyCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyCacheStore(
      HiveLazyAdapter(path ?? '.',
          encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [Vault] backed by a [HiveDefaultVaultStore]
///
/// * [store]: An existing hive store
/// * [vaultName]: The name of the vault
Vault<T> _newHiveDefaultVault<T>(HiveDefaultVaultStore store,
    {String? vaultName}) {
  return Vault<T>.newVault(store, name: vaultName);
}

/// Creates a new [Cache] backed by a [HiveDefaultCacheStore]
///
/// * [store]: An existing hive store
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newHiveDefaultCache<T>(HiveDefaultCacheStore store,
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

/// Creates a new [Vault] backed by a [HiveLazyVaultStore]
///
/// * [store]: An existing hive store
/// * [vaultName]: The name of the vault
Vault<T> _newHiveLazyVault<T>(HiveLazyVaultStore store, {String? vaultName}) {
  return Vault<T>.newVault(store, name: vaultName);
}

/// Creates a new [Cache] backed by a [HiveLazyCacheStore]
///
/// * [store]: An existing hive store
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newHiveLazyCache<T>(HiveLazyCacheStore store,
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

/// Creates a new [Vault] backed by a [HiveDefaultVaultStore]
///
/// * [cacheName]: The name of the cache
/// * [store]: An existing store, note that [fromEncodable], [encryptionCipher] and [crashRecovery] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Vault] backed by a [HiveDefaultVaultStore]
Vault<T> newHiveDefaultVault<T>(
    {String? vaultName,
    HiveDefaultVaultStore? store,
    String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newHiveDefaultVault<T>(
      store ??
          newHiveDefaultVaultStore(
              path: path,
              fromEncodable: fromEncodable,
              encryptionCipher: encryptionCipher,
              crashRecovery: crashRecovery),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by a [HiveDefaultCacheStore]
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
Cache<T> newHiveDefaultCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    HiveDefaultCacheStore? store,
    String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newHiveDefaultCache<T>(
      store ??
          newHiveDefaultCacheStore(
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

/// Creates a new [Vault] backed by a [HiveLazyVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store, note that [fromEncodable], [encryptionCipher] and [crashRecovery] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
///
/// Returns a new [Vault] backed by a [HiveLazyVaultStore]
Vault<T> newLazyHiveVault<T>(
    {String? vaultName,
    HiveLazyVaultStore? store,
    String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newHiveLazyVault<T>(
      store ??
          newHiveLazyVaultStore(
              path: path,
              fromEncodable: fromEncodable,
              encryptionCipher: encryptionCipher,
              crashRecovery: crashRecovery),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by a [HiveLazyCacheStore]
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
/// Returns a new [Cache] backed by a [HiveLazyCacheStore]
Cache<T> newLazyHiveCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    HiveLazyCacheStore? store,
    String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return _newHiveLazyCache<T>(
      store ??
          newHiveLazyCacheStore(
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

/// Extension over [HiveDefaultVaultStore] allowing the creation of multiple vaults from
/// the same store
extension HiveDefaultVaultStoreExtension on HiveDefaultVaultStore {
  Vault<T> vault<T>({String? vaultName}) {
    return _newHiveDefaultVault<T>(this, vaultName: vaultName);
  }
}

/// Extension over [HiveDefaultCacheStore] allowing the creation of multiple caches from
/// the same store
extension HiveDefaultCacheStoreExtension on HiveDefaultCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newHiveDefaultCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}

/// Extension over [HiveLazyVaultStore] allowing the creation of multiple vaults from
/// the same store
extension HiveLazyVaultStoreExtension on HiveLazyVaultStore {
  Vault<T> vault<T>({String? vaultName}) {
    return _newHiveLazyVault<T>(this, vaultName: vaultName);
  }
}

/// Extension over [HiveLazyCacheStore] allowing the creation of multiple caches from
/// the same store
extension HiveLazyCacheStoreExtension on HiveLazyCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newHiveLazyCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
