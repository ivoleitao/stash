import 'package:stash_hive/stash_hive.dart';
import 'package:stash_test/stash_test.dart';

import "vm_store.dart" if (dart.library.js) "web_store.dart";

class VaultStoreContext extends VaultTestContext<HiveVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<HiveVaultStore> newStore() {
    return newVaultStore(fromEncodable);
  }
}

class CacheStoreContext extends CacheTestContext<HiveCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<HiveCacheStore> newStore() {
    return newCacheStore(fromEncodable);
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
}
