import 'package:stash_hive/stash_hive.dart';
import 'package:stash_test/stash_test.dart';

import "vm_store.dart" if (dart.library.js) "web_store.dart";

class VaultStoreContext extends VaultTestContext<HiveVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<HiveVaultStore> newStore() {
    return newVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<HiveCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<HiveCacheStore> newStore() {
    return newCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
