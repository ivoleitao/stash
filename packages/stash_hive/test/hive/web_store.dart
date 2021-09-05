import 'package:stash_hive/stash_hive.dart';

Future<HiveStore> newTestStore(
    dynamic Function(Map<String, dynamic>)? fromEncodable) {
  return Future.value(
      HiveDefaultStore(HiveDefaultAdapter(), fromEncodable: fromEncodable));
}
