import 'dart:typed_data';

import 'package:stash/src/api/codec/msgpack/reader.dart';
import 'package:stash/src/api/codec/msgpack/types.dart' as types;
import 'package:test/test.dart';

void main() {
  void unpackNull() {
    var data = Uint8List.fromList([types.nil]);
    var value = msgPackRead(data);
    expect(value, isNull);
  }

  void unpackFalse() {
    var data = Uint8List.fromList([types.bool_false]);
    var value = msgPackRead(data);
    expect(value, isFalse);
  }

  void unpackTrue() {
    var data = Uint8List.fromList([types.bool_true]);
    var value = msgPackRead(data);
    expect(value, isTrue);
  }

  var isInt = predicate((e) => e is int, 'is an int');

  void unpackPositiveFixInt() {
    var data = Uint8List.fromList([1]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(1));
  }

  void unpackNegativeFixInt() {
    var data = Uint8List.fromList([240]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-16));
  }

  void unpackUint8() {
    var data = Uint8List.fromList([204, 128]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(128));
  }

  void unpackUint16() {
    var data = Uint8List.fromList([205, 128, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(32768));
  }

  void unpackUint32() {
    var data = Uint8List.fromList([206, 128, 0, 0, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(2147483648));
  }

  void unpackUint64() {
    var data =
        Uint8List.fromList([207, 127, 255, 255, 255, 255, 255, 255, 255]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(9223372036854775807));
  }

  void unpackInt8() {
    var data = Uint8List.fromList([208, 128]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-128));
  }

  void unpackInt16() {
    var data = Uint8List.fromList([209, 128, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-32768));
  }

  void unpackInt32() {
    var data = Uint8List.fromList([210, 128, 0, 0, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-2147483648));
  }

  void unpackInt64() {
    var data = Uint8List.fromList([211, 128, 0, 0, 0, 0, 0, 0, 0]);
    var value = msgPackRead(data);
    expect(value, isInt);
    expect(value, equals(-9223372036854775808));
  }

  void unpackDouble() {
    var data = Uint8List.fromList(
        [0xcb, 0x40, 0x09, 0x1e, 0xb8, 0x51, 0xeb, 0x85, 0x1f]);
    var value = msgPackRead(data);
    expect(value, equals(3.14));
  }

  var isString = predicate((e) => e is String, 'is a String');

  void unpackString5() {
    var data = Uint8List.fromList([165, 104, 101, 108, 108, 111]);
    var value = msgPackRead(data);
    expect(value, isString);
    expect(value, equals('hello'));
  }

  void unpackString22() {
    var data = Uint8List.fromList([
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
    ]);
    var value = msgPackRead(data);
    expect(value, isString);
    expect(value, equals('hello there, everyone!'));
  }

  void unpackString256() {
    var data = Uint8List.fromList([218, 1, 0, ...List.filled(256, 65)]);
    var value = msgPackRead(data);
    expect(value, isString);
    expect(
        value,
        equals(
            'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'));
  }

  void unpackStringArray() {
    var data = Uint8List.fromList([
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
    ]);
    var value = msgPackRead(data);
    expect(value, isList);
    expect(value, orderedEquals(['one', 'two', 'three']));
  }

  void unpackIntToStringMap() {
    var data =
        Uint8List.fromList([130, 1, 163, 111, 110, 101, 2, 163, 116, 119, 111]);
    var value = msgPackRead(data);
    expect(value, isMap);
    expect(value[1], equals('one'));
    expect(value[2], equals('two'));
  }

  group('null', () {
    test('unpack', unpackNull);
  });

  group('bool', () {
    test('unpackFalse', unpackFalse);
    test('unpackTrue', unpackTrue);
  });

  group('int', () {
    test('unpackPositiveFixInt', unpackPositiveFixInt);
    test('unpackNegativeFixInt', unpackNegativeFixInt);
    test('unpackUint8', unpackUint8);
    test('unpackUint16', unpackUint16);
    test('unpackUint32', unpackUint32);
    test('unpackUint64', unpackUint64);
    test('unpackInt8', unpackInt8);
    test('unpackInt16', unpackInt16);
    test('unpackInt32', unpackInt32);
    test('unpackInt64', unpackInt64);
  });

  group('double', () {
    test('unpackDouble', unpackDouble);
  });

  group('string', () {
    test('unpackString5', unpackString5);
    test('unpackString22', unpackString22);
    test('unpackString256', unpackString256);
  });

  group('array', () {
    test('unpackStringArray', unpackStringArray);
  });

  group('map', () {
    test('unpackIntToStringMap', unpackIntToStringMap);
  });
}
