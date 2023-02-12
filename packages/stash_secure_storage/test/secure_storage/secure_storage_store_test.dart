import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_secure_storage/stash_secure_storage.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SecureStorageVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<SecureStorageVaultStore> newStore() {
    return newSecureStorageVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<SecureStorageCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<SecureStorageCacheStore> newStore() {
    return newSecureStorageCacheStore();
  }
}

void main() async {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});
  });

  testStore((generator) => VaultStoreContext(generator),
      types: jsonStoreTypeTests);
  testStore((generator) => CacheStoreContext(generator),
      types: jsonStoreTypeTests);
  testVault((generator) => VaultStoreContext(generator),
      types: jsonStoreTypeTests);
  testCache((generator) => CacheStoreContext(generator),
      types: jsonStoreTypeTests);
}
