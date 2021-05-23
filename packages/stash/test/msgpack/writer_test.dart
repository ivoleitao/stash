import 'dart:typed_data';

import 'package:stash/src/msgpack/types.dart' as types;
import 'package:stash/src/msgpack/writer.dart';
import 'package:test/test.dart';

void main() {
  void packNull() {
    var bytes = msgPackWrite(null);
    expect(bytes, orderedEquals([types.nil]));
  }

  void packFalse() {
    var bytes = msgPackWrite(false);
    expect(bytes, orderedEquals([types.bool_false]));
  }

  void packTrue() {
    var bytes = msgPackWrite(true);
    expect(bytes, orderedEquals([types.bool_true]));
  }

  void packPositiveFixInt() {
    var bytes = msgPackWrite(1);
    expect(bytes, orderedEquals([1]));
  }

  void packNegativeFixInt() {
    var bytes = msgPackWrite(-16);
    expect(bytes, orderedEquals([240]));
  }

  void packUint8() {
    var bytes = msgPackWrite(128);
    expect(bytes, orderedEquals([204, 128]));
  }

  void packUint16() {
    var bytes = msgPackWrite(32768);
    expect(bytes, orderedEquals([205, 128, 0]));
  }

  void packUint32() {
    var bytes = msgPackWrite(2147483648);
    expect(bytes, orderedEquals([206, 128, 0, 0, 0]));
  }

  void packInt8() {
    var bytes = msgPackWrite(-128);
    expect(bytes, orderedEquals([208, 128]));
  }

  void packInt16() {
    var bytes = msgPackWrite(-32768);
    expect(bytes, orderedEquals([209, 128, 0]));
  }

  void packInt32() {
    var bytes = msgPackWrite(-2147483648);
    expect(bytes, orderedEquals([210, 128, 0, 0, 0]));
  }

  void packDouble() {
    var bytes = msgPackWrite(3.14);
    expect(bytes,
        orderedEquals([0xcb, 0x40, 0x09, 0x1e, 0xb8, 0x51, 0xeb, 0x85, 0x1f]));
  }

  void packString5() {
    var bytes = msgPackWrite('hello');
    expect(bytes, orderedEquals([165, 104, 101, 108, 108, 111]));
  }

  void packString22() {
    var bytes = msgPackWrite('hello there, everyone!');
    expect(
        bytes,
        orderedEquals([
          182,
          104,
          101,
          108,
          108,
          111,
          32,
          116,
          104,
          101,
          114,
          101,
          44,
          32,
          101,
          118,
          101,
          114,
          121,
          111,
          110,
          101,
          33
        ]));
  }

  void packString256() {
    var bytes = msgPackWrite(
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    expect(bytes, hasLength(259));
    expect(bytes.sublist(0, 3), orderedEquals([218, 1, 0]));
    expect(bytes.sublist(3, 259), everyElement(65));
  }

  void packBin8() {
    var data = Uint8List.fromList(List.filled(32, 65));
    var bytes = msgPackWrite(data);
    expect(bytes.length, equals(34));
    expect(bytes.getRange(0, 2), orderedEquals([0xc4, 32]));
    expect(bytes.getRange(2, bytes.length), orderedEquals(data));
  }

  void packBin16() {
    var data = Uint8List.fromList(List.filled(256, 65));
    var bytes = msgPackWrite(data);
    expect(bytes.length, equals(256 + 3));
    expect(bytes.getRange(0, 3), orderedEquals([0xc5, 1, 0]));
    expect(bytes.getRange(3, bytes.length), orderedEquals(data));
  }

  void packBin32() {
    var data = Uint8List.fromList(List.filled(65536, 65));
    var bytes = msgPackWrite(data);
    expect(bytes.length, equals(65536 + 5));
    expect(bytes.getRange(0, 5), orderedEquals([0xc6, 0, 1, 0, 0]));
    expect(bytes.getRange(5, bytes.length), orderedEquals(data));
  }

  void packByteData() {
    var data = ByteData.view(Uint8List.fromList(List.filled(32, 65)).buffer);
    var bytes = msgPackWrite(data);
    expect(bytes.length, equals(34));
    expect(bytes.getRange(0, 2), orderedEquals([0xc4, 32]));
    expect(bytes.getRange(2, bytes.length),
        orderedEquals(data.buffer.asUint8List()));
  }

  void packStringArray() {
    var encoded = msgPackWrite(['one', 'two', 'three']);
    expect(
        encoded,
        orderedEquals([
          147,
          163,
          111,
          110,
          101,
          163,
          116,
          119,
          111,
          165,
          116,
          104,
          114,
          101,
          101
        ]));
  }

  void packIntToStringMap() {
    var encoded = msgPackWrite({1: 'one', 2: 'two'});
    expect(encoded,
        orderedEquals([130, 1, 163, 111, 110, 101, 2, 163, 116, 119, 111]));
  }

  group('null', () {
    test('packNull', packNull);
  });

  group('bool', () {
    test('packFalse', packFalse);
    test('packTrue', packTrue);
  });

  group('int', () {
    test('packPositiveFixInt', packPositiveFixInt);
    test('packNegativeFixInt', packNegativeFixInt);
    test('packUint8', packUint8);
    test('packUint16', packUint16);
    test('packUint32', packUint32);
    test('packInt8', packInt8);
    test('packInt16', packInt16);
    test('packInt32', packInt32);
  });

  group('double', () {
    test('packDouble', packDouble);
  });

  group('string', () {
    test('packString5', packString5);
    test('packString22', packString22);
    test('packString256', packString256);
  });

  group('binary', () {
    test('packBin8', packBin8);
    test('packBin16', packBin16);
    test('packBin32', packBin32);
    test('packByteData', packByteData);
  });

  group('array', () {
    test('packStringArray', packStringArray);
  });

  group('map', () {
    test('packIntToStringMap', packIntToStringMap);
  });

  group('ext', () {});

  group('object', () {});
}
