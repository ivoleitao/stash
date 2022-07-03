import 'package:stash_file/stash_file.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<FileVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<FileVaultStore> newStore() {
    return newFileMemoryVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<FileCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<FileCacheStore> newStore() {
    return newFileMemoryCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
