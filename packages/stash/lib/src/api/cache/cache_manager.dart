import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/eviction/lru_policy.dart';
import 'package:stash/src/api/cache/expiry/eternal_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/manager/default_manager.dart';
import 'package:stash/src/api/cache/sampler/full_sampler.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
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
  /// * [storage]: The [Store] that will back this [Cache]
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
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
  Cache<T> newCache<T>(Store<CacheInfo, CacheEntry> storage,
      {CacheManager? manager,
      String? name,
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
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance, defaults to [DefaultCacheStats]
  ///
  /// Returns a new [Cache]
  Cache<T> newTieredCache<T>(Cache<T> primary, Cache<T> secondary,
      {CacheManager? manager,
      String? name,
      Clock? clock,
      bool? statsEnabled,
      CacheStats? stats});

  /// Gets an existing [Cache]
  ///
  /// * [name]: The name of the cache
  Cache<T>? get<T>(String name);

  /// Removes a [Cache] from this [CacheManager] if present
  ///
  /// * [name]: The name of the cache
  void remove(String name);
}
