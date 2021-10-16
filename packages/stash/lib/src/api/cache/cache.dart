import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/default_cache.dart';
import 'package:stash/src/api/cache/event/event.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/eviction/lru_policy.dart';
import 'package:stash/src/api/cache/expiry/eternal_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/sampler/full_sampler.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';
import 'package:stash/src/api/event.dart';

import '../stash.dart';
import '../store.dart';

/// Cache loader function
typedef CacheLoader<T> = Future<T> Function(String key);

/// The cache definition and the hub for the creation of caches
abstract class Cache<T> extends Stash<T> {
  /// The default constructor
  Cache();

  /// Builds a new Cache
  ///
  /// * [storage]: The [Store] that will back this [Cache]
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
  factory Cache.newCache(Store<CacheInfo, CacheEntry> storage,
      {String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<T>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return DefaultCache<T>(storage,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

  /// Builds a new Tiered [Cache]
  ///
  /// * [primary]: The primary cache
  /// * [secondary]: The secondary cache
  /// * [name]: The name of the cache
  ///
  /// Returns a new [Cache]
  factory Cache.newTieredCache(Cache<T> primary, Cache<T> secondary,
      {String? name}) {
    return TieredCache<T>(primary, secondary, name: name);
  }

  /// Returns the cache value for the specified [key]. If [expiryDuration] is
  /// specified it uses it instead of the configured expiry policy duration
  ///
  /// * [key]: the key
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  @override
  Future<T?> get(String key, {Duration? expiryDuration});

  /// Add / Replace the cache [value] for the specified [key]. If [expiryDuration]
  /// is specified ir uses it instead of the configured expiry policy duration
  ///
  /// * [key]: the key
  /// * [value]: the value
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  @override
  Future<void> put(String key, T value, {Duration? expiryDuration});

  /// Associates the specified [key] with the given [value]
  /// if not already associated with a value. If [expiryDuration]
  /// is specified ir uses it instead of the configured expiry policy duration
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  ///
  /// Returns `true` if a value was set.
  @override
  Future<bool> putIfAbsent(String key, T value, {Duration? expiryDuration});

  /// Associates the specified [value] with the specified [key] in this cache,
  /// returning an existing value if one existed. If the cache previously contained
  /// a mapping for the [key], the old value is replaced by the specified value.
  /// If [expiryDuration] is specified ir uses it instead of the configured
  /// expiry policy duration
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  @override
  Future<T?> getAndPut(String key, T value, {Duration? expiryDuration});

  /// Listens for events of Type `T` and its subtypes.
  ///
  /// The method is called like this: myCache.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Stream] contains every
  /// event of this [Cache].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  Stream<E> on<E extends CacheEvent<T>>();
}
