/// Provides a in-memory implementation of the Stash caching API for Dart
library stash_memory;

import 'package:stash/stash_api.dart';
import 'package:stash_memory/src/memory/memory_store.dart';

export 'src/memory/memory_store.dart';

/// Creates a new [Cache] backed by a [MemoryStore]
///
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
///
/// Returns a [Cache] backed by a [MemoryStore]
Cache newMemoryCache(
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode}) {
  return Cache.newCache(MemoryStore(),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}
