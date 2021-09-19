/// Provides a Moor implementation of the Stash caching API for Dart
library stash_sqlite;

import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_adapter.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_store.dart';

export 'src/sqlite/sqlite_adapter.dart';
export 'src/sqlite/sqlite_store.dart';

/// Creates a new [Cache] backed by a [SqliteStore]
///
/// * [store]: An existing sqlite store
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
Cache<T> _newSqliteCache<T>(SqliteStore store,
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

/// Creates a new [SqliteStore] on a file
///
/// * [file]: The path to the database file
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseLog]: If [databaseLog] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteStore newSqliteFileStore(
    {File? file,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    bool? databaseLog,
    DatabaseSetup? databaseSetup}) {
  return SqliteStore(
      SqliteFileAdapter(
          file ?? File('${Directory.systemTemp.path}/stash_sqlite.db'),
          logStatements: databaseLog,
          setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by a file based [SqliteStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec], [fromEncodable], [databaseLog] and [databaseSetup] will be ignored if this parameter is provided
/// * [file]: The path to the database file
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseLog]: If [databaseLog] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Cache<T> newSqliteFileCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SqliteStore? store,
    File? file,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    bool? databaseLog,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteCache<T>(
      store ??
          newSqliteFileStore(
              file: file,
              codec: codec,
              fromEncodable: fromEncodable,
              databaseLog: databaseLog,
              databaseSetup: databaseSetup),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Creates a new in-memory [SqliteStore]
///
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseLog]: If [databaseLog] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
SqliteStore newSqliteMemoryStore(
    {CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    bool? databaseLog,
    DatabaseSetup? databaseSetup}) {
  return SqliteStore(
      SqliteMemoryAdapter(logStatements: databaseLog, setup: databaseSetup),
      codec: codec,
      fromEncodable: fromEncodable);
}

/// Creates a new [Cache] backed by in memory [SqliteStore]
///
/// * [cacheName]: The name of the cache
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [eventListenerMode]: The event listener mode of this cache
/// * [store]: An existing store, note that [codec], [fromEncodable], [databaseLog] and [databaseSetup] will be all ignored is this parameter is provided
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseLog]: If [databaseLog] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before moor is fully ready
Cache<T> newSqliteMemoryCache<T>(
    {String? cacheName,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    ExpiryPolicy? expiryPolicy,
    CacheLoader<T>? cacheLoader,
    EventListenerMode? eventListenerMode,
    SqliteStore? store,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    bool? databaseLog,
    DatabaseSetup? databaseSetup}) {
  return _newSqliteCache<T>(
      store ??
          newSqliteMemoryStore(
              codec: codec,
              fromEncodable: fromEncodable,
              databaseLog: databaseLog,
              databaseSetup: databaseSetup),
      cacheName: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      eventListenerMode: eventListenerMode);
}

/// Extension over [SqliteStore] allowing the creation of multiple caches from
/// the same store
extension SqliteStoreExtension on SqliteStore {
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
