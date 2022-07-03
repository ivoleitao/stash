import 'dart:io';

import 'package:stash_isar/stash_isar.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<IsarVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<IsarVaultStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_isar')
        .then((d) => newIsarLocalVaultStore(path: d.path));
  }
}

class CacheStoreContext extends CacheTestContext<IsarCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<IsarCacheStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_isar')
        .then((d) => newIsarLocalCacheStore(path: d.path));
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
