import 'dart:io';

import 'package:stash_isar/stash_isar.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<IsarVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<IsarVaultStore> newStore() {
    return Directory.systemTemp.createTemp('stash_isar').then((d) =>
        newIsarLocalVaultStore(path: d.path, fromEncodable: fromEncodable));
  }
}

class CacheStoreContext extends CacheTestContext<IsarCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<IsarCacheStore> newStore() {
    return Directory.systemTemp.createTemp('stash_isar').then((d) =>
        newIsarLocalCacheStore(path: d.path, fromEncodable: fromEncodable));
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
