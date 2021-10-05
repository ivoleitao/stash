import 'package:stash_hive/stash_hive.dart';

Future<HiveVaultStore> newVaultStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Future.value(newHiveDefaultVaultStore(fromEncodable: fromEncodable));
}

Future<HiveCacheStore> newCacheStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Future.value(newHiveDefaultCacheStore(fromEncodable: fromEncodable));
}
