/// Provides a file implementation of the stash caching API for Dart
library stash_file;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_file/src/file/file_store.dart';

export 'src/file/file_store.dart';

/// Creates a new [Cache] backed by a [FileStore]
///
/// * [store]: An existing file store
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache _newFileCache(FileStore store,
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode}) {
  return Cache.newCache(store,
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new in-memory [FileStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileStore newMemoryFileStore(
    {String? path,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable}) {
  FileSystem fs = MemoryFileSystem();
  return FileStore(fs, path ?? fs.systemTempDirectory.path,
      lock: false, codec: codec, fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a in-memory [FileStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [FileStore]
Cache newMemoryFileCache(
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    FileStore? store,
    String? path,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable}) {
  return _newFileCache(
      store ??
          newMemoryFileStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new in-memory [FileStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileStore newLocalFileStore(
    {String? path,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable}) {
  FileSystem fs = const LocalFileSystem();
  return FileStore(fs, path ?? fs.systemTempDirectory.path,
      codec: codec, fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a local [FileStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be ignored if this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [FileStore]
Cache newLocalFileCache(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader? cacheLoader,
    EventListenerMode? eventListenerMode,
    FileStore? store,
    String? path,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable}) {
  return _newFileCache(
      newLocalFileStore(path: path, codec: codec, fromEncodable: fromEncodable),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [FileStore] allowing the creation of multiple caches from
/// the same store
extension FileStoreExtension on FileStore {
  Cache cache(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newFileCache(this,
        cacheName: cacheName,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        expiryPolicy: expiryPolicy,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
