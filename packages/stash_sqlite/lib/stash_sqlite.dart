/// Provides a Sqlite implementation of the Stash caching API for Dart
library stash_sqlite;

import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/cache_database.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_adapter.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_store.dart';
import 'package:stash_sqlite/src/sqlite/vault_database.dart';

export 'src/sqlite/sqlite_adapter.dart';
export 'src/sqlite/sqlite_store.dart';

/// Creates a new in-memory [SqliteVaultStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteVaultStore newSqliteMemoryVaultStore(
    {StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return SqliteVaultStore(
      SqliteMemoryAdapter((QueryExecutor executor) => VaultDatabase(executor),
          logStatements: logStatements, setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new in-memory [SqliteCacheStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteCacheStore newSqliteMemoryCacheStore(
    {StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return SqliteCacheStore(
      SqliteMemoryAdapter((QueryExecutor executor) => CacheDatabase(executor),
          logStatements: logStatements, setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [SqliteVaultStore] on a file
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteVaultStore newSqliteLocalVaultStore(
    {File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return SqliteVaultStore(
      SqliteFileAdapter((QueryExecutor executor) => VaultDatabase(executor),
          file ?? File('${Directory.systemTemp.path}/stash_sqlite.db'),
          logStatements: logStatements, setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [SqliteCacheStore] on a file
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteCacheStore newSqliteLocalCacheStore(
    {File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return SqliteCacheStore(
      SqliteFileAdapter((QueryExecutor executor) => CacheDatabase(executor),
          file ?? File('${Directory.systemTemp.path}/stash_sqlite.db'),
          logStatements: logStatements, setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [Vault] backed by a [SqliteVaultStore]
///
/// * [store]: An existing file store
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Vault<T> _newSqliteVault<T>(SqliteVaultStore store,
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

/// Creates a new [Cache] backed by a [SqliteCacheStore]
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
Cache<T> _newSqliteCache<T>(SqliteCacheStore store,
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

/// Creates a new [Vault] backed by in memory [SqliteVaultStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be all ignored is this parameter is provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Vault] backed by a [SqliteVaultStore]
Vault<T> newSqliteMemoryVault<T>(
    {SqliteVaultStore? store,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newSqliteVault<T>(
      store ??
          newSqliteMemoryVaultStore(
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Vault] backed by a file based [SqliteVaultStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be ignored if this parameter is provided
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
/// * [manager]: An optional [VaultManager]
/// * [vaultName]: The name of the vault
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
///
/// Returns a new [Vault] backed by a [SqliteVaultStore]
Vault<T> newSqliteLocalVault<T>(
    {SqliteVaultStore? store,
    File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    VaultManager? manager,
    String? vaultName,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return _newSqliteVault<T>(
      store ??
          newSqliteLocalVaultStore(
              file: file,
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      manager: manager,
      vaultName: vaultName,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [Cache] backed by in memory [SqliteCacheStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be all ignored is this parameter is provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
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
/// Returns a new [Cache] backed by a [SqliteCacheStore]
Cache<T> newSqliteMemoryCache<T>(
    {SqliteCacheStore? store,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
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
  return _newSqliteCache<T>(
      store ??
          newSqliteMemoryCacheStore(
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
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

/// Creates a new [Cache] backed by a file based [SqliteCacheStore]
///
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be ignored if this parameter is provided
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
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
/// Returns a new [Cache] backed by a [SqliteCacheStore]
Cache<T> newSqliteLocalCache<T>(
    {SqliteCacheStore? store,
    File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
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
  return _newSqliteCache<T>(
      store ??
          newSqliteLocalCacheStore(
              file: file,
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
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
