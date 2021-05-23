import 'dart:io';

import 'package:stash_isar/stash_isar.dart';
import 'package:stash_test/stash_test.dart';
import 'package:test/test.dart';

class DefaultContext extends TestContext<IsarStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<IsarStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_isar')
        .then((d) => IsarStore(fromEncodable: fromEncodable));
  }
}

void main() async {
  test('dummy', () async {});
  //testStore((generator) => DefaultContext(generator), types: {}, tests: {});
  //testCache((generator) => DefaultContext(generator), types: {}, tests: {});
}
