import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/eviction/lru_policy.dart';
import 'package:stash/src/api/cache/expiry/eternal_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/manager/default_manager.dart';
import 'package:stash/src/api/cache/sampler/full_sampler.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';

import 'cache.dart';
import 'cache_entry.dart';
import 'cache_info.dart';

abstract class CacheManager {
  /// The default instance of the [CacheManager]
  static final CacheManager instance = DefaultCacheManager();

  /// Returns a [Iterable] over all the [Cache] names
  Iterable<String> get names;

  /// Builds a new Cache
  ///
  /// * [store]: The [Store] that will back this [Cache]
  /// * [name]: The name of the cache
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
  /// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
  /// * [evictionPolicy]: The eviction policy to use, defaults to [LruEvictionPolicy] if not provided
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a new DefaultCache
  Future<Cache<T>> newGenericCache<T>(Store<CacheInfo, CacheEntry> store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<T>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats});

  /// Builds a new Tiered [Cache]
  ///
  /// * [primary]: The primary cache
  /// * [secondary]: The secondary cache
  /// * [name]: The name of the cache
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a new [Cache]
  TieredCache<T> newTieredCache<T>(Cache<T> primary, Cache<T> secondary,
      {String? name, Clock? clock, bool? statsEnabled, CacheStats? stats});

  /// Gets an existing [Cache]
  ///
  /// * [name]: The name of the cache
  V? get<T, V extends Cache<T>>(String name);

  /// Gets an existing [Cache]
  ///
  /// * [name]: The name of the cache
  Cache<T>? getCache<T>(String name) {
    return get<T, Cache<T>>(name);
  }

  /// Gets an existing [TieredCache]
  ///
  /// * [name]: The name of the tiered cache
  TieredCache<T>? getTieredCache<T>(String name) {
    return get<T, TieredCache<T>>(name);
  }

  /// Removes a [Cache] from this [CacheManager] if present
  ///
  /// * [name]: The name of the cache
  void remove(String name);
}
