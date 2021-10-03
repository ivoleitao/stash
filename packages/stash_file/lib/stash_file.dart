/// Provides a file implementation of the stash caching API for Dart
library stash_file;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_file/src/file/file_store.dart';

export 'src/file/file_store.dart';

/// Creates a new in-memory [FileVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileVaultStore newFileMemoryVaultStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  FileSystem fs = MemoryFileSystem();
  return FileVaultStore(fs, path ?? fs.systemTempDirectory.path,
      lock: false, codec: codec, fromEncodable: fromEncodable);
}

/// Creates a new in-memory [FileCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileCacheStore newFileMemoryCacheStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  FileSystem fs = MemoryFileSystem();
  return FileCacheStore(fs, path ?? fs.systemTempDirectory.path,
      lock: false, codec: codec, fromEncodable: fromEncodable);
}

/// Creates a local [FileVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileVaultStore newFileLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  FileSystem fs = const LocalFileSystem();
  return FileVaultStore(fs, path ?? fs.systemTempDirectory.path,
      codec: codec, fromEncodable: fromEncodable);
}

/// Creates a local [FileCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
FileCacheStore newFileLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  FileSystem fs = const LocalFileSystem();
  return FileCacheStore(fs, path ?? fs.systemTempDirectory.path,
      codec: codec, fromEncodable: fromEncodable);
}

/// Creates a new [Vault] backed by a [FileVaultStore]
///
/// * [store]: An existing file store
/// * [vaultName]: The name of the vault
Vault<T> _newFileVault<T>(FileVaultStore store, {String? vaultName}) {
  return Vault<T>.newVault(store, name: vaultName);
}

/// Creates a new [Cache] backed by a [FileCacheStore]
///
/// * [store]: An existing file store
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newFileCache<T>(FileCacheStore store,
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

/// Creates a new [Vault] backed by a in-memory [FileVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Vault] backed by a [FileVaultStore]
Vault<T> newFileMemoryVault<T>(
    {String? vaultName,
    FileVaultStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  return _newFileVault<T>(
      store ??
          newFileMemoryVaultStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      vaultName: vaultName);
}

/// Creates a new [Vault] backed by a local [FileVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be ignored if this parameter is provided
/// * [path]: The base storage location for this vault
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Vault] backed by a [FileVaultStore]
Vault<T> newFileLocalVault<T>(
    {String? vaultName,
    FileVaultStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  return _newFileVault<T>(
      newFileLocalVaultStore(
          path: path, codec: codec, fromEncodable: fromEncodable),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by a in-memory [FileCacheStore]
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
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [FileCacheStore]
Cache<T> newFileMemoryCache<T>(
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    FileCacheStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  return _newFileCache<T>(
      store ??
          newFileMemoryCacheStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [Cache] backed by a local [FileCacheStore]
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
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
///
/// Returns a new [Cache] backed by a [FileCacheStore]
Cache<T> newFileLocalCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    FileStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable}) {
  return _newFileCache<T>(
      newFileLocalCacheStore(
          path: path, codec: codec, fromEncodable: fromEncodable),
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [FileVaultStore] allowing the creation of multiple vaults from
/// the same store
extension FileVaultStoreExtension on FileVaultStore {
  Vault<T> vault<T>({String? vaultName}) {
    return _newFileVault<T>(this, vaultName: vaultName);
  }
}

/// Extension over [FileCacheStore] allowing the creation of multiple caches from
/// the same store
extension FileCacheStoreExtension on FileCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newFileCache<T>(this,
        cacheName: cacheName,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        expiryPolicy: expiryPolicy,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
