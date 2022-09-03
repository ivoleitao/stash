/// Standard caching API for Dart. Defines a common mechanism to create,
/// access, update, and remove information from caches.
library stash_api;

import 'src/api/cache/cache.dart';
import 'src/api/cache/cache_entry.dart';
import 'src/api/cache/cache_info.dart';
import 'src/api/cache/cache_manager.dart';
import 'src/api/cache/cache_stats.dart';
import 'src/api/cache/eviction/eviction_policy.dart';
import 'src/api/cache/expiry/expiry_policy.dart';
import 'src/api/cache/sampler/sampler.dart';
import 'src/api/event.dart';
import 'src/api/store.dart';
import 'src/api/vault/vault.dart';
import 'src/api/vault/vault_entry.dart';
import 'src/api/vault/vault_info.dart';
import 'src/api/vault/vault_manager.dart';
import 'src/api/vault/vault_stats.dart';

export 'src/api/cache/cache.dart';
export 'src/api/cache/cache_entry.dart';
export 'src/api/cache/cache_info.dart';
export 'src/api/cache/cache_manager.dart';
export 'src/api/cache/cache_stats.dart';
export 'src/api/cache/cache_store.dart';
export 'src/api/cache/event/created_event.dart';
export 'src/api/cache/event/event.dart';
export 'src/api/cache/event/evicted_event.dart';
export 'src/api/cache/event/expired_event.dart';
export 'src/api/cache/event/removed_event.dart';
export 'src/api/cache/event/updated_event.dart';
export 'src/api/cache/eviction/eviction_policy.dart';
export 'src/api/cache/eviction/fifo_policy.dart';
export 'src/api/cache/eviction/filo_policy.dart';
export 'src/api/cache/eviction/hyperbolic_policy.dart';
export 'src/api/cache/eviction/lfu_policy.dart';
export 'src/api/cache/eviction/lru_policy.dart';
export 'src/api/cache/eviction/mfu_policy.dart';
export 'src/api/cache/eviction/mru_policy.dart';
export 'src/api/cache/expiry/accessed_policy.dart';
export 'src/api/cache/expiry/created_policy.dart';
export 'src/api/cache/expiry/eternal_policy.dart';
export 'src/api/cache/expiry/expiry_policy.dart';
export 'src/api/cache/expiry/modified_policy.dart';
export 'src/api/cache/expiry/touched_policy.dart';
export 'src/api/cache/generic_cache.dart';
export 'src/api/cache/manager/default_manager.dart';
export 'src/api/cache/sampler/full_sampler.dart';
export 'src/api/cache/sampler/sampler.dart';
export 'src/api/cache/tiered_cache.dart';
export 'src/api/codec/bytes_reader.dart';
export 'src/api/codec/bytes_util.dart';
export 'src/api/codec/bytes_writer.dart';
export 'src/api/codec/store_codec.dart';
export 'src/api/entry.dart';
export 'src/api/event.dart';
export 'src/api/info.dart';
export 'src/api/stash.dart';
export 'src/api/store.dart';
export 'src/api/vault/event/created_event.dart';
export 'src/api/vault/event/event.dart';
export 'src/api/vault/event/removed_event.dart';
export 'src/api/vault/event/updated_event.dart';
export 'src/api/vault/generic_vault.dart';
export 'src/api/vault/manager/default_manager.dart';
export 'src/api/vault/vault.dart';
export 'src/api/vault/vault_entry.dart';
export 'src/api/vault/vault_info.dart';
export 'src/api/vault/vault_manager.dart';
export 'src/api/vault/vault_stats.dart';
export 'src/api/vault/vault_store.dart';

/// Builds a new Tiered [Cache]
///
/// * [manager]: An optional [CacheManager]
/// * [primary]: The primary cache
/// * [secondary]: The secondary cache
/// * [name]: The name of the cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Cache<T> newTieredCache<T>(
    CacheManager? manager, Cache<T> primary, Cache<T> secondary,
    {String? name, bool? statsEnabled, CacheStats? stats}) {
  return (manager ?? CacheManager.instance).newTieredCache(primary, secondary,
      name: name, statsEnabled: statsEnabled, stats: stats);
}

/// Extension over [Store] allowing the creation of multiple vaults from
/// the same store
extension VaultExtension on Store<VaultInfo, VaultEntry> {
  /// Creates a new [Vault] backed by a [Store]
  ///
  /// * [store]: An existing store
  /// * [manager]: An optional [VaultManager]
  /// * [name]: The name of the vault
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a [Vault] backed by a [Store]
  Future<Vault<T>> _newGenericVault<T>(Store<VaultInfo, VaultEntry> store,
      {VaultManager? manager,
      String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return (manager ?? VaultManager.instance).newGenericVault<T>(store,
        name: name,
        fromEncodable: fromEncodable,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

  /// Creates a new [Vault] backed by a [Store]
  ///
  /// * [manager]: An optional [VaultManager]
  /// * [name]: The name of the vault
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a [Vault] backed by a [Store]
  Future<Vault<T>> vault<T>(
      {VaultManager? manager,
      String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return _newGenericVault<T>(this,
        manager: manager,
        name: name,
        fromEncodable: fromEncodable,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }
}

/// Extension over [Store] allowing the creation of multiple caches from
/// the same store
extension CacheExtension on Store<CacheInfo, CacheEntry> {
  /// Creates a new [Cache] backed by a [Store]
  ///
  /// * [store]: An existing store
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [expiryPolicy]: The expiry policy to use
  /// * [sampler]: The sampler to use upon eviction of a cache element
  /// * [evictionPolicy]: The eviction policy to use
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Future<Cache<T>> _newGenericCache<T>(Store<CacheInfo, CacheEntry> store,
      {CacheManager? manager,
      String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return (manager ?? CacheManager.instance).newGenericCache<T>(store,
        name: name,
        fromEncodable: fromEncodable,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

  /// Creates a new [Cache] backed by a [Store]
  ///
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [expiryPolicy]: The expiry policy to use
  /// * [sampler]: The sampler to use upon eviction of a cache element
  /// * [evictionPolicy]: The eviction policy to use
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a [Cache] backed by a [Store]
  Future<Cache<T>> cache<T>(
      {CacheManager? manager,
      String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return _newGenericCache<T>(this,
        manager: manager,
        name: name,
        fromEncodable: fromEncodable,
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
