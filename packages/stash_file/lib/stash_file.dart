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
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Vault<T> _newFileVault<T>(FileVaultStore store,
    {VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return (manager ?? VaultManager.instance).newVault<T>(store,
      name: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a [FileCacheStore]
///
/// * [store]: An existing file store
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Cache<T> _newFileCache<T>(FileCacheStore store,
    {CacheManager? manager,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return (manager ?? CacheManager.instance).newCache<T>(store,
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Vault] backed by a in-memory [FileVaultStore]
///
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Vault] backed by a [FileVaultStore]
Vault<T> newFileMemoryVault<T>(
    {FileVaultStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newFileVault<T>(
      store ??
          newFileMemoryVaultStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Vault] backed by a local [FileVaultStore]
///
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be ignored if this parameter is provided
/// * [path]: The base storage location for this vault
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Vault] backed by a [FileVaultStore]
Vault<T> newFileLocalVault<T>(
    {FileVaultStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newFileVault<T>(
      store ??
          newFileLocalVaultStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a in-memory [FileCacheStore]
///
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be all ignored is this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Cache] backed by a [FileCacheStore]
Cache<T> newFileMemoryCache<T>({
  FileCacheStore? store,
  String? path,
  StoreCodec? codec,
  dynamic Function(Map<String, dynamic>)? fromEncodable,
  CacheManager? manager,
  String? cacheName,
  ExpiryPolicy? expiryPolicy,
  KeySampler? sampler,
  EvictionPolicy? evictionPolicy,
  int? maxEntries,
  CacheLoader<T>? cacheLoader,
  EventListenerMode? eventListenerMode,
  bool? statsEnabled,
  CacheStats? stats,
}) {
  return _newFileCache<T>(
      store ??
          newFileMemoryCacheStore(
              path: path, codec: codec, fromEncodable: fromEncodable),
      manager: manager,
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by a local [FileCacheStore]
///
/// * [store]: An existing store, note that [codec] and [fromEncodable] will be ignored if this parameter is provided
/// * [path]: The base storage location for this cache
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [manager]: An optional [CacheManager]
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Cache] backed by a [FileCacheStore]
Cache<T> newFileLocalCache<T>(
    {FileStore? store,
    String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    CacheManager? manager,
    String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return _newFileCache<T>(
      newFileLocalCacheStore(
          path: path, codec: codec, fromEncodable: fromEncodable),
      manager: manager,
      cacheName: cacheName,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      expiryPolicy: expiryPolicy,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Extension over [FileVaultStore] allowing the creation of multiple vaults from
/// the same store
extension FileVaultStoreExtension on FileVaultStore {
  /// Creates a new [Vault] backed by a [FileVaultStore]
  ///
  /// * [manager]: An optional [VaultManager]
  /// * [vaultName]: The name of the vault
  /// * [eventListenerMode]: The event listener mode of this vault
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Vault<T> vault<T>(
      {VaultManager? manager,
      String? vaultName,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return _newFileVault<T>(this,
        manager: manager,
        vaultName: vaultName,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }
}
