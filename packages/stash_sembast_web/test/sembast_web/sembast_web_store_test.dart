import 'package:stash_sembast/stash_sembast.dart';
import 'package:stash_sembast_web/stash_sembast_web.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SembastVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<SembastVaultStore> newStore() {
    return newSembastWebVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<SembastCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<SembastCacheStore> newStore() {
    return newSembastWebCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
