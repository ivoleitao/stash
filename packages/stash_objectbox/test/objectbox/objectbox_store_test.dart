import 'dart:io';

import 'package:stash_objectbox/stash_objectbox.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<ObjectboxVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<ObjectboxVaultStore> newStore() {
    return Directory.systemTemp.createTemp('stash_objectbox').then((d) =>
        newObjectboxLocalVaultStore(
            path: d.path, queriesCaseSensitiveDefault: true));
  }
}

class CacheStoreContext extends CacheTestContext<ObjectboxCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<ObjectboxCacheStore> newStore() {
    return Directory.systemTemp.createTemp('stash_objectbox').then((d) =>
        newObjectboxLocalCacheStore(
            path: d.path, queriesCaseSensitiveDefault: true));
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
