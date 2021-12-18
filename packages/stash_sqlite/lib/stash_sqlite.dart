/// Provides a Sqlite implementation of the Stash caching API for Dart
library stash_sqlite;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/cache_database.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_adapter.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_store.dart';
import 'package:stash_sqlite/src/sqlite/vault_database.dart';

export 'package:stash/stash_api.dart';

export 'src/sqlite/sqlite_adapter.dart';
export 'src/sqlite/sqlite_store.dart';

/// Creates a new in-memory [SqliteVaultStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [logStatements]: If [logStatements] is true (defaults to `false`), generated sql statements will be printed before executing
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
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
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
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
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
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
/// * [databaseSetup]: This optional function can be used to perform a setup just after the database is opened, before drift is fully ready
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
