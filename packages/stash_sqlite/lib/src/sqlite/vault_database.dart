import 'package:moor/moor.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/dao/dao_adapter.dart';
import 'package:stash_sqlite/src/sqlite/dao/vault_dao.dart';
import 'package:stash_sqlite/src/sqlite/table/iso8601_converter.dart';
import 'package:stash_sqlite/src/sqlite/table/vault_table.dart';

import 'sqlite_database.dart';

part 'vault_database.g.dart';

@UseMoor(tables: [VaultTable], daos: [VaultDao])

/// The vault database class
class VaultDatabase extends _$VaultDatabase
    implements SqliteDatabase<VaultStat, VaultEntry> {
  /// The version if the schema
  static const int _schemaVersion = 1;

  /// Builds a [VaultDatabase]
  ///
  /// * [executor]: The [QueryExecutor] to user
  VaultDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => _schemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      if (details.wasCreated) {}
      await customStatement('PRAGMA foreign_keys = ON;');
    });
  }

  @override
  DaoAdapter<VaultStat, VaultEntry> get dao => vaultDao;
}
