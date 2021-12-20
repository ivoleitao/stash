```dart
import 'package:stash_custom/stash_custom.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<CustomVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<CustomVaultStore> _newCustomStore() {
    return Future.value(newCustomVaultStore(fromEncodable: fromEncodable));
  }

  @override
  Future<CustomVaultStore> newStore() {
    return _newCustomStore();
  }
}

class CacheStoreContext extends CacheTestContext<CustomCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<CustomCacheStore> _newCustomStore() {
    return Future.value(newCustomCacheStore(fromEncodable: fromEncodable));
  }

  @override
  Future<CustomCacheStore> newStore() {
    return _newCustomStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}

```