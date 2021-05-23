import 'dart:io';

import 'package:stash_objectbox/src/objectbox/objectbox_adapter.dart';
import 'package:stash_objectbox/stash_objectbox.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<ObjectboxStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<ObjectboxStore> newStore() {
    return Directory.systemTemp.createTemp('stash_objectbox').then((dir) =>
        ObjectboxStore(
            ObjectboxAdapter(dir.path, queriesCaseSensitiveDefault: true),
            fromEncodable: fromEncodable));
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
