import 'package:stash/src/api/cache/cache_manager.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/event/event.dart';

import '../stash.dart';

/// Cache loader function
typedef CacheLoader<T> = Future<T> Function(String key);

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

  /// Returns the cache value for the specified [key]. If [expiryDuration] is
  /// specified it uses it instead of the configured expiry policy duration
  ///
  /// * [key]: the key
  /// * [expiryDuration]: Expiry duration to be used in place of the configured expiry policy duration
  @override
  Future<T?> get(String key);

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
