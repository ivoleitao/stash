import 'dart:io';

import 'package:stash_hive/stash_hive.dart';

Future<HiveVaultStore> newVaultStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Directory.systemTemp.createTemp('stash_hive').then((d) =>
      newHiveDefaultVaultStore(path: d.path, fromEncodable: fromEncodable));
}

Future<HiveCacheStore> newCacheStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Directory.systemTemp.createTemp('stash_hive').then((d) =>
      newHiveDefaultCacheStore(path: d.path, fromEncodable: fromEncodable));
}
