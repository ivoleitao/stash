import 'package:stash_memory/stash_memory.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<MemoryVaultStore> {
  VaultStoreContext(ValueGenerator generator) : super(generator);

  @override
  Future<MemoryVaultStore> newStore() {
    return newMemoryVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<MemoryCacheStore> {
  CacheStoreContext(ValueGenerator generator) : super(generator);

  @override
  Future<MemoryCacheStore> newStore() {
    return newMemoryCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
