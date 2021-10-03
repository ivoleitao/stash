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
/// * [store]: An existing sqlite store
/// * [vaultName]: The name of the vault
Vault<T> _newSqliteVault<T>(SqliteVaultStore store, {String? vaultName}) {
  return Vault<T>.newVault(store, name: vaultName);
}

/// Creates a new [Cache] backed by a [SqliteCacheStore]
///
/// * [store]: An existing sqlite store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newSqliteCache<T>(SqliteCacheStore store,
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

/// Creates a new [Vault] backed by in memory [SqliteVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be all ignored is this parameter is provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Vault<T> newSqliteMemoryVault<T>(
    {String? vaultName,
    SqliteVaultStore? store,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteVault<T>(
      store ??
          newSqliteMemoryVaultStore(
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by in memory [SqliteCacheStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be all ignored is this parameter is provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Cache<T> newSqliteMemoryCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SqliteCacheStore? store,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteCache<T>(
      store ??
          newSqliteMemoryCacheStore(
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new [Vault] backed by a file based [SqliteVaultStore]
///
/// * [vaultName]: The name of the vault
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be ignored if this parameter is provided
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Vault<T> newSqliteLocalVault<T>(
    {String? vaultName,
    SqliteVaultStore? store,
    File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteVault<T>(
      store ??
          newSqliteLocalVaultStore(
              file: file,
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      vaultName: vaultName);
}

/// Creates a new [Cache] backed by a file based [SqliteCacheStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec], [fromEncodable], [logStatements] and [databaseSetup] will be ignored if this parameter is provided
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Cache<T> newSqliteLocalCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SqliteCacheStore? store,
    File? file,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    bool? logStatements,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteCache<T>(
      store ??
          newSqliteLocalCacheStore(
              file: file,
              codec: codec,
              fromEncodable: fromEncodable,
              logStatements: logStatements,
              databaseSetup: databaseSetup),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [SqliteVaultStore] allowing the creation of multiple vaults from
/// the same store
extension SqliteVaultStoreExtension on SqliteVaultStore {
  Vault<T> vault<T>({String? vaultName}) {
    return _newSqliteVault<T>(this, vaultName: vaultName);
  }
}

/// Extension over [SqliteCacheStore] allowing the creation of multiple caches from
/// the same store
extension SqliteCacheStoreExtension on SqliteCacheStore {
  Cache<T> cache<T>(
      {String? cacheName,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      ExpiryPolicy? expiryPolicy,
      CacheLoader<T>? cacheLoader,
      EventListenerMode? eventListenerMode}) {
    return _newSqliteCache<T>(this,
        cacheName: cacheName,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        eventListenerMode: eventListenerMode);
  }
}
