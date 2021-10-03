import 'dart:io';

import 'package:stash_objectbox/stash_objectbox.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<ObjectboxCacheStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<ObjectboxCacheStore> newStore() {
    return Directory.systemTemp.createTemp('stash_objectbox').then((d) =>
        newObjectboxCacheStore(
            path: d.path,
            queriesCaseSensitiveDefault: true,
            fromEncodable: fromEncodable));
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
