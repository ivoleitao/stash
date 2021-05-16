/// Provides a Sembast implementation of the Stash caching API for Dart
library stash_sembast;

import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_adapter.dart';
import 'package:stash_sembast/src/sembast/sembast_store.dart';

export 'src/sembast/sembast_adapter.dart';
export 'src/sembast/sembast_store.dart';

/// Creates a new [Cache] backed by a [SembastStore]
///
/// * [file]: The location of this cache
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
///
/// Returns a new [Cache] backed by a [SembastStore]
Cache newSembastFileCache(File file,
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    dynamic Function(dynamic)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return Cache.newCache(
      SembastStore(
          SembastFileAdapter(file,
              version: databaseVersion,
              onVersionChanged: onVersionChanged,
              mode: databaseMode,
              codec: sembastCodec),
          fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader);
}

/// Creates a new [Cache] backed by a in-memory [SembastStore]
///
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
///
/// Returns a new [Cache] backed by a [SembastStore]
Cache newSembastMemoryCache(
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    dynamic Function(dynamic)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return Cache.newCache(
      SembastStore(
          SembastMemoryAdapter(cacheName ?? 'sembast',
              version: databaseVersion,
              onVersionChanged: onVersionChanged,
              mode: databaseMode,
              codec: sembastCodec),
          fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader);
}
