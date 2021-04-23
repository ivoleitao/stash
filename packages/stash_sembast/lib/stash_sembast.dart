/// Provides a Sembast implementation of the Stash caching API for Dart
library stash_sembast;

import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_store.dart';

export 'src/sembast/sembast_store.dart';

/// Creates a new [Cache] backed by a [SembastStore]
///
/// * [path]: The base storage location for this cache
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [SembastStore]
Cache newSembastCache(String path,
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    dynamic Function(dynamic)? fromEncodable}) {
  return Cache.newCache(SembastStore(path, fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader);
}
