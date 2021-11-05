import 'package:drift/drift.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_store.dart';
import 'package:stash_sqlite/stash_sqlite.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SqliteVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SqliteVaultStore> newStore() {
    return Future.value(
        newSqliteMemoryVaultStore(fromEncodable: fromEncodable));
  }
}

class CacheStoreContext extends CacheTestContext<SqliteCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SqliteCacheStore> newStore() {
    return Future.value(
        newSqliteMemoryCacheStore(fromEncodable: fromEncodable));
  }
}

void main() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
