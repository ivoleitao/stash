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
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Vault<T> _newMemoryVault<T>(MemoryVaultStore store,
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

/// Creates a new [Cache] backed by a [MemoryCacheStore]
///
/// * [store]: An existing memory store
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Cache<T> _newMemoryCache<T>(MemoryCacheStore store,
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

/// Creates a new [Vault] backed by a [MemoryVaultStore]
///
/// * [manager]: An optional [VaultManager]
/// * [store]: An existing store
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a [Vault] backed by a [MemoryVaultStore]
Vault<T> newMemoryVault<T>(
    {VaultManager? manager,
    MemoryVaultStore? store,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newMemoryVault<T>(store ?? newMemoryVaultStore(),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a [MemoryStore]
///
/// * [manager]: An optional [CacheManager]
/// * [store]: An existing store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a [Cache] backed by a [MemoryCacheStore]
Cache<T> newMemoryCache<T>(
    {CacheManager? manager,
    MemoryCacheStore? store,
    String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return _newMemoryCache<T>(store ?? newMemoryCacheStore(),
      manager: manager,
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
