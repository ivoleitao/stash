import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_shared_preferences/stash_shared_preferences.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SharedPreferencesVaultStore> {
  VaultStoreContext(super.generator);

  @override
  Future<SharedPreferencesVaultStore> newStore() {
    return newSharedPreferencesVaultStore();
  }
}

class CacheStoreContext extends CacheTestContext<SharedPreferencesCacheStore> {
  CacheStoreContext(super.generator);

  @override
  Future<SharedPreferencesCacheStore> newStore() {
    return newSharedPreferencesCacheStore();
  }
}

void main() async {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
