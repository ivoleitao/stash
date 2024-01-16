import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/dao/dao_adapter.dart';

/// Bridge between the two types of databases supported, the VaultDatabase and
/// the CacheDatabase
abstract class SqliteDatabase<I extends Info, E extends Entry<I>> {
  /// Gets the specific version of the dao, either VaultDao or CacheDao
  DaoAdapter<I, E> get dao;

  /// Closes the database
  Future<void> close();
}
