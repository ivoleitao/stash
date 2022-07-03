```dart
import 'package:stash_custom/stash_custom.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<CustomVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<CustomVaultStore> newStore() {
    return newCustomVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<CustomCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<CustomCacheStore> newStore() {
    return newCustomCacheStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}

```