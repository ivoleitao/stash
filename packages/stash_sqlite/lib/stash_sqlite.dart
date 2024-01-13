/// Provides a Sqlite implementation of the Stash caching API for Dart
library stash_sqlite;

import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
Future<SqliteVaultStore> newSqliteMemoryVaultStore(
    {StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements}) {
  return SqliteMemoryAdapter.build<VaultInfo, VaultEntry>(
          (QueryExecutor executor) => VaultDatabase(executor),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements)
      .then((adapter) => SqliteVaultStore(adapter, codec: codec));
}

/// Creates a new in-memory [SqliteCacheStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
Future<SqliteCacheStore> newSqliteMemoryCacheStore(
    {StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements}) {
  return SqliteMemoryAdapter.build<CacheInfo, CacheEntry>(
          (QueryExecutor executor) => CacheDatabase(executor),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements)
      .then((adapter) => SqliteCacheStore(adapter, codec: codec));
}

/// Provides the default vault file
///
/// * [file]: An optional file
File _defaultVaultFile(File? file) =>
    file ?? File('${Directory.systemTemp.path}/vault.db');

/// Creates a file based [SqliteVaultStore]
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
Future<SqliteVaultStore> newSqliteLocalVaultStore(
    {File? file,
    StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements}) {
  return SqliteFileAdapter.build<VaultInfo, VaultEntry>(
          (QueryExecutor executor) => VaultDatabase(executor),
          _defaultVaultFile(file),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements)
      .then((adapter) => SqliteVaultStore(adapter, codec: codec));
}

/// Creates a file based [SqliteVaultStore] on a background isolate
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
/// * [isolateSetup]: function that can perform setup work on the isolate before opening the database.
Future<SqliteVaultStore> newSqliteBackgroundVaultStore(
    {File? file,
    StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements,
    FutureOr<void> Function()? isolateSetup}) {
  return SqliteBackgroundFileAdapter.build<VaultInfo, VaultEntry>(
          (QueryExecutor executor) => VaultDatabase(executor),
          _defaultVaultFile(file),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements,
          isolateSetup: isolateSetup)
      .then((adapter) => SqliteVaultStore(adapter, codec: codec));
}

/// Provides the default cache file
///
/// * [file]: An optional file
File _defaultCacheFile(File? file) =>
    file ?? File('${Directory.systemTemp.path}/cache.db');

/// Creates a file based [SqliteCacheStore]
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
Future<SqliteCacheStore> newSqliteLocalCacheStore(
    {File? file,
    StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements}) {
  return SqliteFileAdapter.build<CacheInfo, CacheEntry>(
          (QueryExecutor executor) => CacheDatabase(executor),
          _defaultCacheFile(file),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements)
      .then((adapter) => SqliteCacheStore(adapter, codec: codec));
}

/// Creates a file based [SqliteCacheStore] on a background isolate
///
/// * [file]: The path to the database file
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
/// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
/// * [isolateSetup]: function that can perform setup work on the isolate before opening the database.
Future<SqliteCacheStore> newSqliteBackgroundCacheStore(
    {File? file,
    StoreCodec? codec,
    bool? logStatements,
    DatabaseSetup? databaseSetup,
    bool? cachePreparedStatements,
    FutureOr<void> Function()? isolateSetup}) {
  return SqliteBackgroundFileAdapter.build<CacheInfo, CacheEntry>(
          (QueryExecutor executor) => CacheDatabase(executor),
          _defaultCacheFile(file),
          logStatements: logStatements,
          setup: databaseSetup,
          cachePreparedStatements: cachePreparedStatements)
      .then((adapter) => SqliteCacheStore(adapter, codec: codec));
}
