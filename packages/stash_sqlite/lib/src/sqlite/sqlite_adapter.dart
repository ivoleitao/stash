import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/dao/dao_adapter.dart';

import 'sqlite_database.dart';

typedef SqliteBuilder<S extends Stat, E extends Entry<S>> = SqliteDatabase<S, E>
    Function(QueryExecutor executor);

/// The [SqliteAdapter] provides a bridge between the store and the
/// Sqlite backend
abstract class SqliteAdapter<S extends Stat, E extends Entry<S>> {
  /// The [SqliteDatabase] to use
  late final SqliteDatabase<S, E> _db;

  /// Builds a [SqliteAdapter].
  SqliteAdapter();

  /// Returns the [DaoAdapter] for the underlining [Store]
  DaoAdapter<S, E> get dao => _db.dao;

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
class SqliteMemoryAdapter<S extends Stat, E extends Entry<S>>
    extends SqliteAdapter<S, E> {
  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteMemoryAdapter(SqliteBuilder<S, E> builder,
      {bool? logStatements, DatabaseSetup? setup}) {
    _db = builder(
        VmDatabase.memory(logStatements: logStatements ?? false, setup: setup));
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
class SqliteFileAdapter<S extends Stat, E extends Entry<S>>
    extends SqliteAdapter<S, E> {
  final File file;

  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [file]: The [File] that store the Sqlite database
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteFileAdapter(SqliteBuilder<S, E> builder, this.file,
      {bool? logStatements, DatabaseSetup? setup}) {
    _db = builder(
        VmDatabase(file, logStatements: logStatements ?? false, setup: setup));
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
