import 'dart:io';

import 'package:stash_hive/stash_hive.dart';

Future<HiveStore> newTestStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Directory.systemTemp.createTemp('stash_hive').then((d) =>
      HiveDefaultStore(HiveDefaultAdapter(path: d.path),
          fromEncodable: fromEncodable));
}
