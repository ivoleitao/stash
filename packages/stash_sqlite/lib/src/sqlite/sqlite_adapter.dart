import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:stash_sqlite/src/sqlite/dao/cache_dao.dart';

import 'cache_database.dart';

/// The [CacheStoreAdapter] provides a bridge between the store and the
/// backend
abstract class CacheStoreAdapter {
  /// Deletes a named cache from a store or the store itself if a named cache is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name);

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named caches in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll();
}

/// The [SqliteAdapter] provides a bridge between the store and the
/// Sqlite backend
abstract class SqliteAdapter extends CacheStoreAdapter {
  /// The [CacheDatabase] to use
  late final CacheDatabase _cacheStore;

  /// Generated sql statements will be printed before executing.
  final bool? logStatements;

  /// Retrieves the appropriate executor
  QueryExecutor executor();

  /// Builds a [SqliteAdapter].
  ///
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteAdapter({this.logStatements}) {
    _cacheStore = CacheDatabase(executor());
  }

  /// Returns the [CacheDao] for the underlining [CacheDatabase]
  CacheDao get dao => _cacheStore.cacheDao;

  CacheDatabase store(String name) {
    return _cacheStore;
  }
}

/// The [SqliteMemoryAdapter] provides a bridge between the store and the
/// Sqlite in-memory backend
class SqliteMemoryAdapter extends SqliteAdapter {
  /// Function that can be used to perform a setup just after
  /// the database is opened, before moor is fully ready
  final DatabaseSetup? setup;

  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteMemoryAdapter({bool? logStatements, this.setup})
      : super(logStatements: logStatements);

  @override
  QueryExecutor executor() {
    return VmDatabase.memory(
        logStatements: logStatements ?? false, setup: setup);
  }

  @override
  Future<void> delete(String name) {
    return _cacheStore.cacheDao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return _cacheStore.cacheDao.clearAll();
  }
}

/// The [SqliteFileAdapter] provides a bridge between the store and the
/// Sqlite backend
class SqliteFileAdapter extends SqliteAdapter {
  /// The [File] that store the Sqlite database
  final File file;

  /// Function that can be used to perform a setup just after
  /// the database is opened, before moor is fully ready
  final DatabaseSetup? setup;

  /// Builds a [SqliteMemoryAdapter].
  ///
  /// * [file]: The [File] that store the Sqlite database
  /// * [logStatements]: Generated sql statements will be printed before executing
  /// * [setup]: Function that can be used to perform a setup just after the database is opened
  SqliteFileAdapter(this.file, {bool? logStatements, this.setup})
      : super(logStatements: logStatements);

  @override
  QueryExecutor executor() {
    return VmDatabase(file,
        logStatements: logStatements ?? false, setup: setup);
  }

  @override
  Future<void> delete(String name) {
    return _cacheStore.cacheDao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return file.delete();
  }
}
