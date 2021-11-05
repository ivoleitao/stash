import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/dao/dao_adapter.dart';

import 'sqlite_database.dart';

typedef SqliteBuilder<I extends Info, E extends Entry<I>> = SqliteDatabase<I, E>
    Function(QueryExecutor executor);

/// The [SqliteAdapter] provides a bridge between the store and the
/// Sqlite backend
abstract class SqliteAdapter<I extends Info, E extends Entry<I>> {
  /// The [SqliteDatabase] to use
  late final SqliteDatabase<I, E> _db;

  /// Builds a [SqliteAdapter].
  SqliteAdapter();

  /// Returns the [DaoAdapter] for the underlining [Store]
  DaoAdapter<I, E> get dao => _db.dao;

  /// Deletes a named store or the store itself
  ///
  /// * [name]: The vault/cache name
  Future<void> delete(String name);

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named caches in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll();
}

/// The [SqliteMemoryAdapter] provides a bridge between the store and the
/// Sqlite in-memory backend
class SqliteMemoryAdapter<I extends Info, E extends Entry<I>>
    extends SqliteAdapter<I, E> {
  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteMemoryAdapter(SqliteBuilder<I, E> builder,
      {bool? logStatements, DatabaseSetup? setup}) {
    _db = builder(
        NativeDatabase.memory(logStatements: logStatements ?? false, setup: setup));
  }

  @override
  Future<void> delete(String name) {
    return dao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return dao.clearAll();
  }
}

/// The [SqliteFileAdapter] provides a bridge between the store and the
/// Sqlite backend
class SqliteFileAdapter<I extends Info, E extends Entry<I>>
    extends SqliteAdapter<I, E> {
  final File file;

  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [file]: The [File] that store the Sqlite database
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteFileAdapter(SqliteBuilder<I, E> builder, this.file,
      {bool? logStatements, DatabaseSetup? setup}) {
    _db = builder(
        NativeDatabase(file, logStatements: logStatements ?? false, setup: setup));
  }

  @override
  Future<void> delete(String name) {
    return dao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return file.delete();
  }
}
