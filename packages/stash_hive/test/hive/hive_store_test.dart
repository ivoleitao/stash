import 'dart:io';

import 'package:stash_hive/src/hive/hive_adapter.dart';
import 'package:stash_hive/stash_hive.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<HiveStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<HiveStore> newStore() {
    return Directory.systemTemp.createTemp('stash_hive').then((d) =>
        HiveDefaultStore(HiveDefaultAdapter(d.path),
            fromEncodable: fromEncodable));
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
