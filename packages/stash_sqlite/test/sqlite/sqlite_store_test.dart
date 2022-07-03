import 'package:drift/drift.dart';
import 'package:stash_sqlite/stash_sqlite.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SqliteVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<SqliteVaultStore> newStore() {
    return newSqliteMemoryVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<SqliteCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<SqliteCacheStore> newStore() {
    return newSqliteMemoryCacheStore();
  }
}

void main() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
