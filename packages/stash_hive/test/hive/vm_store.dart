import 'dart:io';

import 'package:stash_hive/stash_hive.dart';

Future<HiveVaultStore> newVaultStore() {
  return Directory.systemTemp
      .createTemp('stash_hive')
      .then((d) => newHiveDefaultVaultStore(path: d.path));
}

Future<HiveCacheStore> newCacheStore() {
  return Directory.systemTemp
      .createTemp('stash_hive')
      .then((d) => newHiveDefaultCacheStore(path: d.path));
}
