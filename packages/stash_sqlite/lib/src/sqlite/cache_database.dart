import 'package:moor/moor.dart';
import 'package:stash_sqlite/src/sqlite/dao/cache_dao.dart';
import 'package:stash_sqlite/src/sqlite/table/cache_table.dart';
import 'package:stash_sqlite/src/sqlite/table/iso8601_converter.dart';

part 'cache_database.g.dart';

@UseMoor(tables: [
  CacheTable,
], daos: [
  CacheDao
])

/// The database class
class CacheDatabase extends _$CacheDatabase {
  /// The version if the schema
  static const int _schemaVersion = 1;

  /// Builds a [CacheDatabase]
  ///
  /// * [executor]: The [QueryExecutor] to user
  CacheDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => _schemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      if (details.wasCreated) {}
      await customStatement('PRAGMA foreign_keys = ON;');
    });
  }
}
