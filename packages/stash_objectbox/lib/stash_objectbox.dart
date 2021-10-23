/// Provides a Objectbox implementation of the Stash caching API for Dart
library stash_objectbox;

import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_adapter.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_store.dart';

export 'src/objectbox/objectbox_adapter.dart';
export 'src/objectbox/objectbox_store.dart';

/// Creates a new [ObjectboxVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
ObjectboxVaultStore newObjectboxLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return ObjectboxVaultStore(
      ObjectboxAdapter(path ?? Directory.systemTemp.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [ObjectboxCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
ObjectboxCacheStore newObjectboxLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return ObjectboxCacheStore(
      ObjectboxAdapter(path ?? Directory.systemTemp.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [Vault] backed by a [ObjectboxVaultStore]
///
/// * [store]: An existing objectbox store
/// * [manager]: An optional [VaultManager]
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Vault<T> _newObjectboxVault<T>(ObjectboxVaultStore store,
    {VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return (manager ?? VaultManager.instance).newVault<T>(store,
      name: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Vault] backed by a [ObjectboxVaultStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [path], [maxDBSizeInKB], [fileMode], [maxReaders] and [queriesCaseSensitiveDefault] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Vault] backed by a [ObjectboxVaultStore]
Vault<T> newObjectBoxVault<T>(
    {ObjectboxVaultStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault,
    VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newObjectboxVault<T>(
      store ??
          newObjectboxLocalVaultStore(
              path: path,
              codec: codec,
              fromEncodable: fromEncodable,
              maxDBSizeInKB: maxDBSizeInKB,
              fileMode: fileMode,
              maxReaders: maxReaders,
              queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a [ObjectboxCacheStore]
///
/// * [store]: An existing objectbox store
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Cache<T> _newObjectboxCache<T>(ObjectboxCacheStore store,
    {CacheManager? manager,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return (manager ?? CacheManager.instance).newCache<T>(store,
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a [ObjectboxCacheStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [path], [maxDBSizeInKB], [fileMode], [maxReaders] and [queriesCaseSensitiveDefault] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Cache] backed by a [ObjectboxCacheStore]
Cache<T> newObjectBoxCache<T>(
    {String? path,
    ObjectboxCacheStore? store,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault,
    CacheManager? manager,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return _newObjectboxCache<T>(
      newObjectboxLocalCacheStore(
          path: path,
          codec: codec,
          fromEncodable: fromEncodable,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      manager: manager,
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Extension over [ObjectboxVaultStore] allowing the creation of multiple vaults from
/// the same store
extension ObjectboxVaultStoreExtension on ObjectboxVaultStore {
  /// Creates a new [Vault] backed by a [ObjectboxVaultStore]
  ///
  /// * [manager]: An optional [VaultManager]
  /// * [vaultName]: The name of the vault
  /// * [eventListenerMode]: The event listener mode of this vault
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Vault<T> vault<T>(
      {VaultManager? manager,
      String? vaultName,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return _newObjectboxVault<T>(this,
        manager: manager,
        vaultName: vaultName,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }
}

/// Extension over [ObjectboxCacheStore] allowing the creation of multiple caches from
/// the same store
extension ObjectboxCacheStoreExtension on ObjectboxCacheStore {
  /// Creates a new [Cache] backed by a [ObjectboxCacheStore]
  ///
  /// * [manager]: An optional [CacheManager]
  /// * [cacheName]: The name of the cache
  /// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
  /// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
  /// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Cache<T> cache<T>(
      {CacheManager? manager,
      String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return _newObjectboxCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }
}
