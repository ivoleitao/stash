@TestOn('!js')
import 'dart:typed_data';

import 'package:stash/src/msgpack/reader.dart';
import 'package:test/test.dart';

void main() {
  var isInt = predicate((e) => e is int, 'is an int');

  void unpackUint64() {
    var data =
        Uint8List.fromList([207, 127, 255, 255, 255, 255, 255, 255, 255]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(9223372036854775807));
  }

  void unpackInt64() {
    var data = Uint8List.fromList([211, 128, 0, 0, 0, 0, 0, 0, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-9223372036854775808));
  }

  group('int', () {
    test('unpackUint64', unpackUint64);
    test('unpackInt64', unpackInt64);
  });
}
