import 'package:stash_hive/stash_hive.dart';

Future<HiveCacheStore> newTestStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Future.value(newHiveDefaultCacheStore(fromEncodable: fromEncodable));
}
