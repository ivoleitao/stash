import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_manager.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/event/event.dart';

import '../stash.dart';

/// Cache loader function
typedef CacheLoader<T> = Future<T> Function(String key);

/// Cache entry builder delegate
typedef CacheEntryBuilderDelegate<T> = CacheEntryBuilder<T> Function(
    CacheEntryBuilder<T> delegate);

/// The cache definition and the hub for the creation of caches
abstract class Cache<T> extends Stash<T> {
  // void loadAll(Set<? extends K> keys, boolean replaceExistingValues, CompletionListener completionListener);
  // CacheManager getCacheManager();

  /// Gets the [CacheManager] that owns and manages the [Cache].
  /// Returns the manager or `null` if the [Cache] is not managed
  CacheManager? get manager;

  // If the statistics should be collected
  bool get statsEnabled;

  // Gets the cache stats
  CacheStats get stats;

  /// Returns the cache value for the specified [key].
  ///
  /// * [key]: the key
  /// * [delegate]: provides the caller a way of changing the [CacheEntry] before persistence
  @override
  Future<T?> get(String key, {CacheEntryBuilderDelegate<T>? delegate});

  /// Add / Replace the cache [value] for the specified [key].
  ///
  /// * [key]: the key
  /// * [value]: the value
  /// * [delegate]: provides the caller a way of changing the [CacheEntry] before persistence
  @override
  Future<void> put(String key, T value,
      {CacheEntryBuilderDelegate<T>? delegate});

  /// Associates the specified [key] with the given [value]
  /// if not already associated with a value.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [delegate]: provides the caller a way of changing the [CacheEntry] before persistence
  ///
  /// Returns `true` if a value was set.
  @override
  Future<bool> putIfAbsent(String key, T value,
      {CacheEntryBuilderDelegate<T>? delegate});

  /// Associates the specified [value] with the specified [key] in this cache,
  /// returning an existing value if one existed. If the cache previously contained
  /// a mapping for the [key], the old value is replaced by the specified value.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  /// * [delegate]: provides the caller a way of changing the [CacheEntry] before persistence
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  @override
  Future<T?> getAndPut(String key, T value,
      {CacheEntryBuilderDelegate<T>? delegate});

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
