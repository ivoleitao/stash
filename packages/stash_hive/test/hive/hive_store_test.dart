import 'package:stash_hive/stash_hive.dart';
import 'package:stash_test/stash_test.dart';

import "vm_store.dart" if (dart.library.js) "web_store.dart";

class DefaultContext extends TestContext<HiveStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<HiveStore> newStore() {
    return newTestStore(fromEncodable);
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
