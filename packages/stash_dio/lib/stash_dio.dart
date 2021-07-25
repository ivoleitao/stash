/// A cache extension for Dio using the stash caching library
library stash_dio;

import 'package:dio/dio.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_dio/src/dio/interceptor_builder.dart';
import 'package:stash_memory/stash_memory.dart';

export 'src/dio/cache_interceptor.dart';

/// Creates a new [Interceptor] backed by the provided [Cache]
///
/// * [pattern]: All the calls with a url matching this pattern will be cached
///
/// Returns a [Interceptor]
Interceptor newCacheInterceptor(String pattern, Cache cache) {
  return (CacheInterceptorBuilder()..cache(pattern, cache)).build();
}

/// Creates a new [Interceptor] backed by a [Cache] with [MemoryStore] storage
///
/// * [pattern]: All the calls with a url matching this pattern will be cached
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store
///
/// Returns a [Interceptor]
Interceptor newMemoryCacheInterceptor(String pattern, String cacheName,
    {KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    MemoryStore? store}) {
  return newCacheInterceptor(
      pattern,
      newMemoryCache(
          cacheName: cacheName,
          evictionPolicy: evictionPolicy,
          sampler: sampler,
          expiryPolicy: expiryPolicy,
          maxEntries: maxEntries,
          cacheLoader: cacheLoader,
          eventListenerMode: eventListenerMode,
          store: store));
}

/// Creates a new [Interceptor] backed by a primary and a secondary [Cache]
///
/// * [pattern]: All the calls with a url matching this pattern will be cached
/// * [primary]: The primary cache
/// * [secondary]: The secondary cache
///
/// Returns a [Interceptor]
Interceptor newTieredCacheInterceptor(
    String pattern, Cache primary, Cache secondary) {
  return newCacheInterceptor(pattern, newTieredCache(primary, secondary));
}
