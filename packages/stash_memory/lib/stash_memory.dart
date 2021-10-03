/// Provides a in-memory implementation of the Stash caching API for Dart
library stash_memory;

import 'package:stash/stash_api.dart';
import 'package:stash_memory/src/memory/memory_store.dart';

export 'src/memory/memory_store.dart';

/// Creates a new [MemoryVaultStore]
MemoryVaultStore newMemoryVaultStore() {
  return MemoryVaultStore();
}

/// Creates a new [MemoryCacheStore]
MemoryCacheStore newMemoryCacheStore() {
  return MemoryCacheStore();
}

/// Creates a new [Vault] backed by a [MemoryVaultStore]
///
/// * [store]: An existing sqlite store
/// * [vaultName]: The name of the vault
Vault<T> _newMemoryVault<T>(MemoryVaultStore store, {String? vaultName}) {
  return Vault<T>.newVault(store, name: vaultName);
}

/// Creates a new [Cache] backed by a [MemoryCacheStore]
///
/// * [store]: An existing sqlite store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newMemoryCache<T>(MemoryCacheStore store,
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

/// Creates a new [Vault] backed by a [MemoryVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store
///
/// Returns a [Vault] backed by a [MemoryVaultStore]
Vault<T> newMemoryVault<T>({String? vaultName, MemoryVaultStore? store}) {
  return _newMemoryVault<T>(store ?? newMemoryVaultStore(),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by a [MemoryStore]
///
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store
///
/// Returns a [Cache] backed by a [MemoryCacheStore]
Cache<T> newMemoryCache<T>(
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    MemoryCacheStore? store}) {
  return _newMemoryCache<T>(store ?? newMemoryCacheStore(),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [MemoryVaultStore] allowing the creation of multiple vaults from
/// the same store
extension MemoryVaultStoreExtension on MemoryVaultStore {
  Vault<T> vault<T>({String? vaultName}) {
    return newMemoryVault<T>(store: this, vaultName: vaultName);
  }
}

/// Extension over [MemoryCacheStore] allowing the creation of multiple caches from
/// the same store
extension MemoryCacheStoreExtension on MemoryCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return newMemoryCache<T>(
        store: this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
