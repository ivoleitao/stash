import 'package:stash_isar/stash_isar.dart';
import 'package:stash_test/stash_test.dart';

import "vm_store.dart" if (dart.library.js) "web_store.dart";

class VaultStoreContext extends VaultTestContext<IsarVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<IsarVaultStore> newStore() {
    return newVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<IsarCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<IsarCacheStore> newStore() {
    return newCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
