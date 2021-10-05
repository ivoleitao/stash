import 'package:stash_file/stash_file.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<FileVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<FileVaultStore> _newMemoryStore() {
    return Future.value(newFileMemoryVaultStore(fromEncodable: fromEncodable));
  }

  @override
  Future<FileVaultStore> newStore() {
    return _newMemoryStore();
  }
}

class CacheStoreContext extends CacheTestContext<FileCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<FileCacheStore> _newMemoryStore() {
    return Future.value(newFileMemoryCacheStore(fromEncodable: fromEncodable));
  }

  @override
  Future<FileCacheStore> newStore() {
    return _newMemoryStore();
  }
}

void main() async {
  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
