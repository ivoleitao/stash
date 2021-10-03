import 'dart:io';

import 'package:stash_hive/stash_hive.dart';

Future<HiveCacheStore> newTestStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Directory.systemTemp.createTemp('stash_hive').then(
      (d) => newHiveCacheStore(path: d.path, fromEncodable: fromEncodable));
}
