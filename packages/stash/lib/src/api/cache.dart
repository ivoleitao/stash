import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/default_cache.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/event/event.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';
import 'package:stash/src/api/expiry/expiry_policy.dart';
import 'package:stash/src/api/sampler/sampler.dart';

/// Cache loader function
typedef CacheLoader = Future<dynamic?> Function(String key);

/// The Stash cache definition and the hub for the creation of the [Cache] caches
abstract class Cache {
  /// The default constructor
  Cache();

  /// Builds a new Cache
  ///
  /// * [storage]: The [CacheStore] that will back this [Cache]
  /// * [name]: The name of the cache
  /// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
  /// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
  /// * [evictionPolicy]: The eviction policy to use, defaults to [LruEvictionPolicy] if not provided
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  ///
  /// Returns a new DefaultCache
  factory Cache.newCache(CacheStore storage,
      {String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader? cacheLoader,
      Clock? clock}) {
    return DefaultCache(storage,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock);
  }

  /// Builds a new Tiered [Cache]
  ///
  /// * [primary]: The primary cache
  /// * [secondary]: The secondary cache
  ///
  /// Returns a new [Cache]
  factory Cache.newTieredCache(Cache primary, Cache secondary) {
    return TieredCache(primary, secondary);
  }

  /// The number of entries on the cache
  Future<int> get size;

  /// Returns a [Iterable] over all the [Cache] keys
  Future<Iterable<String>> get keys;

  /// Determines if the [Cache] contains an entry for the specified [key].
  ///
  /// * [key]: key whose presence in this cache is to be tested.
  ///
  /// Returns `true` if this [Cache] contains a mapping for the specified [key]
  /// and the value is not expired
  Future<bool> containsKey(String key);

  /// Returns the cache value for the specified [key]. If specified [expiryDuration] is used
  /// instead of the configured expiry policy duration
  ///
  /// * [key]: the key
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  Future<dynamic?> get(String key, {Duration? expiryDuration});

  /// Add / Replace the cache [value] for the specified [key]. If specified [expiryDuration] is used
  /// instead of the configured expiry policy duration
  ///
  /// * [key]: the key
  /// * [value]: the value
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  Future<void> put(String key, dynamic value, {Duration? expiryDuration});

  /// Get the cache value for the specified [key].
  ///
  /// * [key]: the key
  Future<dynamic?> operator [](String key);

  /// Associates the specified [key] with the given [value]
  /// if not already associated with a value.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// Returns `true` if a value was set.
  Future<bool> putIfAbsent(String key, dynamic value,
      {Duration? expiryDuration});

  /// Clears the contents of the cache
  Future<void> clear();

  /// Removes the mapping for a key from this cache if it is present.
  ///
  /// * [key]: key whose mapping is to be removed from the cache
  ///
  /// Returns `true` if this cache previously associated the [key], or `false`
  /// if the cache contained no mapping for the [key]. The cache will not
  /// contain a mapping for the specified [key] once the call returns.
  Future<void> remove(String key);

  /// Associates the specified [value] with the specified [key] in this cache,
  /// returning an existing value if one existed. If the cache previously contained
  /// a mapping for the [key], the old value is replaced by the specified value
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  Future<dynamic?> getAndPut(String key, dynamic value,
      {Duration? expiryDuration});

  /// Removes the entry for a [key] only if currently mapped to some value.
  ///
  /// * [key]: key with which the specified value is associated
  ///
  /// Returns the value if one existed or `null` if no mapping existed for this [key]
  Future<dynamic?> getAndRemove(String key);

  /// Listens for events of Type [T] and its subtypes.
  ///
  /// The method is called like this: myCache.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Stream] contains every
  /// event of this [Cache].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  Stream<T> on<T extends CacheEvent>();
}
