import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/dao/dao_adapter.dart';

import 'sqlite_database.dart';

typedef SqliteBuilder<I extends Info, E extends Entry<I>> = SqliteDatabase<I, E>
    Function(QueryExecutor executor);

/// The [SqliteAdapter] provides a bridge between the store and the
/// Sqlite backend
abstract class SqliteAdapter<I extends Info, E extends Entry<I>> {
  /// The [SqliteDatabase] to use
  final SqliteDatabase<I, E> _db;

  /// [SqliteAdapter] constructor.
  ///
  /// * [_db]: The database
  SqliteAdapter(this._db);

  /// Returns the [DaoAdapter] of the underlining [SqliteDatabase]
  DaoAdapter<I, E> get dao => _db.dao;

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) => Future.value();

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> delete(String name);

  /// Deletes all partitions
  Future<void> deleteAll();
}

/// The [SqliteMemoryAdapter] provides a bridge between the store and the
/// Sqlite in-memory backend
class SqliteMemoryAdapter<I extends Info, E extends Entry<I>>
    extends SqliteAdapter<I, E> {
  /// [SqliteMemoryAdapter] constructor
  ///
  /// * [db]: The database
  SqliteMemoryAdapter._(super.db);

  /// Builds [SqliteMemoryAdapter].
  ///
  /// * [builder]: Database builder
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  /// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
  static Future<SqliteAdapter<I, E>> build<I extends Info, E extends Entry<I>>(
      SqliteBuilder<I, E> builder,
      {bool? logStatements,
      DatabaseSetup? setup,
      bool? cachePreparedStatements}) {
    return Future.value(SqliteMemoryAdapter._(builder(NativeDatabase.memory(
        logStatements: logStatements ?? false,
        setup: setup,
        cachePreparedStatements: cachePreparedStatements ?? false))));
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

/// The [SqliteFileBaseAdapter] provides a base abstraction for bridge between
/// the store and the Sqlite file backend
abstract class SqliteFileBaseAdapter<I extends Info, E extends Entry<I>>
    extends SqliteAdapter<I, E> {
  /// The database file
  final File file;

  /// [SqliteFileBaseAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [file]: The [File] that store the Sqlite database
  SqliteFileBaseAdapter(super.db, this.file);

  @override
  Future<void> delete(String name) {
    return dao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return file.delete();
  }
}

/// The [SqliteFileAdapter] provides a bridge between the store and the
/// Sqlite file backend
class SqliteFileAdapter<I extends Info, E extends Entry<I>>
    extends SqliteFileBaseAdapter<I, E> {
  /// [SqliteFileAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [file]: The [File] that store the Sqlite database
  SqliteFileAdapter._(super.db, super.file);

  /// Builds [SqliteFileAdapter].
  ///
  /// * [builder]: Database builder
  /// * [file]: The [File] that store the Sqlite database
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  /// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
  static Future<SqliteAdapter<I, E>> build<I extends Info, E extends Entry<I>>(
      SqliteBuilder<I, E> builder, File file,
      {bool? logStatements,
      DatabaseSetup? setup,
      bool? cachePreparedStatements}) {
    return Future.value(SqliteFileAdapter._(
        builder(NativeDatabase(file,
            logStatements: logStatements ?? false,
            setup: setup,
            cachePreparedStatements: cachePreparedStatements ?? false)),
        file));
  }
}

/// The [SqliteBackgroundFileAdapter] provides a bridge between the store and the
/// background Sqlite file backend
class SqliteBackgroundFileAdapter<I extends Info, E extends Entry<I>>
    extends SqliteFileBaseAdapter<I, E> {
  /// [SqliteBackgroundFileAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [file]: The [File] that store the Sqlite database
  SqliteBackgroundFileAdapter._(super.db, super.file);

  /// Builds [SqliteBackgroundFileAdapter].
  ///
  /// * [builder]: Database builder
  /// * [file]: The [File] that store the Sqlite database
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  /// * [cachePreparedStatements]: controls whether drift will cache prepared statement objects
  /// * [isolateSetup]: function that can perform setup work on the isolate before opening the database.
  static Future<SqliteAdapter<I, E>> build<I extends Info, E extends Entry<I>>(
      SqliteBuilder<I, E> builder, File file,
      {bool? logStatements,
      DatabaseSetup? setup,
      bool? cachePreparedStatements,
      FutureOr<void> Function()? isolateSetup}) {
    return Future.value(SqliteBackgroundFileAdapter._(
        builder(NativeDatabase.createInBackground(file,
            logStatements: logStatements ?? false,
            setup: setup,
            cachePreparedStatements: cachePreparedStatements ?? false)),
        file));
  }
}
