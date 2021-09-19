/// Provides a Objectbox implementation of the Stash caching API for Dart
library stash_objectbox;

import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_adapter.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_store.dart';

export 'src/objectbox/objectbox_adapter.dart';
export 'src/objectbox/objectbox_store.dart';

/// Creates a new [Cache] backed by a [ObjectboxStore]
///
/// * [store]: An existing objectbox store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newObjectboxCache<T>(ObjectboxStore store,
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

/// Creates a new [ObjectboxStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
ObjectboxStore newObjectboxStore(
    {String? path,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return ObjectboxStore(
      ObjectboxAdapter(path ?? Directory.systemTemp.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a [ObjectboxStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec], [fromEncodable], [path], [maxDBSizeInKB], [fileMode], [maxReaders] and [queriesCaseSensitiveDefault] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
///
/// Returns a new [Cache] backed by a [ObjectboxStore]
Cache<T> newObjectBoxCache<T>(
    {String? path,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    CacheStore? store,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return _newObjectboxCache<T>(
      newObjectboxStore(
          path: path,
          codec: codec,
          fromEncodable: fromEncodable,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [ObjectboxStore] allowing the creation of multiple caches from
/// the same store
extension ObjectboxStoreExtension on ObjectboxStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newObjectboxCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
