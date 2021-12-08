/// A cache extension for Dio using the stash caching library
library stash_dio;

import 'package:dio/dio.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_dio/src/dio/interceptor_builder.dart';

export 'src/dio/cache_interceptor.dart';

/// Creates a new [Interceptor] backed by the provided [Cache]
///
/// * [pattern]: All the calls with a url matching this pattern will be cached
///
/// Returns a [Interceptor]
Interceptor newCacheInterceptor(String pattern, Cache cache) {
  return (CacheInterceptorBuilder()..cache(pattern, cache)).build();
}

extension InterceptorExtension on Store<CacheInfo, CacheEntry> {
  /// Creates a new [Interceptor] backed by a [Store]
  ///
  /// * [manager]: An optional [CacheManager]
  /// * [cacheName]: The name of the cache
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
  Interceptor interceptor<T>(String pattern, String cacheName,
      {CacheManager? manager,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return newCacheInterceptor(
        pattern,
        cache(
            manager: manager,
            cacheName: cacheName,
            evictionPolicy: evictionPolicy,
            sampler: sampler,
            expiryPolicy: expiryPolicy,
            maxEntries: maxEntries,
            cacheLoader: cacheLoader,
            eventListenerMode: eventListenerMode,
            statsEnabled: statsEnabled,
            stats: stats));
  }
}
