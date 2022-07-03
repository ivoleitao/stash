import 'package:stash_hive/stash_hive.dart';

Future<HiveVaultStore> newVaultStore() {
  return Future.value(newHiveDefaultVaultStore());
}

Future<HiveCacheStore> newCacheStore() {
  return Future.value(newHiveDefaultCacheStore());
}
