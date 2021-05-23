@TestOn('!js')
import 'package:stash/src/msgpack/writer.dart';
import 'package:test/test.dart';

void main() {
  void packUint64() {
    var bytes = msgPackWrite(9223372036854775807);
    expect(bytes, orderedEquals([207, 127, 255, 255, 255, 255, 255, 255, 255]));
  }

  void packInt64() {
    var bytes = msgPackWrite(-9223372036854775808);
    expect(bytes, orderedEquals([211, 128, 0, 0, 0, 0, 0, 0, 0]));
  }

  group('int', () {
    test('packUint64', packUint64);
    test('packInt64', packInt64);
  });
}
