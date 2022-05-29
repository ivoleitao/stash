import 'package:stash_sembast/stash_sembast.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SembastVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SembastVaultStore> newStore() {
    return newSembastMemoryVaultStore(fromEncodable: fromEncodable);
  }
}

class CacheStoreContext extends CacheTestContext<SembastCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SembastCacheStore> newStore() {
    return newSembastMemoryCacheStore(fromEncodable: fromEncodable);
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator),
      types: jsonStoreTypeTests);
  testStore((generator) => CacheStoreContext(generator),
      types: jsonStoreTypeTests);
  testVault((generator) => VaultStoreContext(generator),
      types: jsonStoreTypeTests);
  testCache((generator) => CacheStoreContext(generator),
      types: jsonStoreTypeTests);
}
