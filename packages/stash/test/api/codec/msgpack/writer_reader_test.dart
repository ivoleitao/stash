import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:stash/src/api/codec/msgpack/extension.dart';
import 'package:stash/src/api/codec/msgpack/reader.dart';
import 'package:stash/src/api/codec/msgpack/writer.dart';
import 'package:test/test.dart';

class FixExt1 extends Equatable {
  final int data;

  FixExt1(this.data);

  @override
  List<Object> get props => [data];
}

class FixExt2 extends Equatable {
  final int data = 1;

  FixExt2();

  @override
  List<Object> get props => [data];
}

class FixExt4 extends Equatable {
  final int data = 1;

  FixExt4();

  @override
  List<Object> get props => [data];
}

class FixExt8 extends Equatable {
  final int data = 1;

  FixExt8();

  @override
  List<Object> get props => [data];
}

class FixExt16 extends Equatable {
  final int data = 1;

  FixExt16();

  @override
  List<Object> get props => [data];
}

class Ext8 extends Equatable {
  final int data = 1;

  Ext8();

  @override
  List<Object> get props => [data];
}

class Ext16 extends Equatable {
  final int data = 1;

  Ext16();

  @override
  List<Object> get props => [data];
}

class Ext32 extends Equatable {
  final int data = 1;

  Ext32();

  @override
  List<Object> get props => [data];
}

class FixExt1Extension extends MsgPackExtension {
  static const int FixExt1Type = 2;

  const FixExt1Extension() : super(FixExt1Type);

  @override
  bool doWrite(MsgPackWriter writer, dynamic object) {
    if (object is FixExt1) {
      writer.writeUint8(object.data);

      return true;
    }

    return false;
  }

  @override
  dynamic doRead(MsgPackReader reader) {
    return FixExt1(reader.readUInt8());
  }
}

void main() {
  void packUnpackNull() {
    var bytes = msgPackWrite(null);
    var value = msgPackRead(bytes);
    expect(value, isNull);
  }

  void packUnpackFalse() {
    var bytes = msgPackWrite(false);
    var value = msgPackRead(bytes);
    expect(value, isFalse);
  }

  void packUnpackTrue() {
    var bytes = msgPackWrite(true);
    var value = msgPackRead(bytes);
    expect(value, isTrue);
  }

  void packUnpackPositiveFixInt() {
    var bytes = msgPackWrite(1);
    var value = msgPackRead(bytes);
    expect(value, 1);
  }

  void packUnpackNegativeFixInt() {
    var bytes = msgPackWrite(-16);
    var value = msgPackRead(bytes);
    expect(value, -16);
  }

  void packUnpackUint8() {
    var bytes = msgPackWrite(128);
    var value = msgPackRead(bytes);
    expect(value, 128);
  }

  void packUnpackUint16() {
    var bytes = msgPackWrite(32768);
    var value = msgPackRead(bytes);
    expect(value, 32768);
  }

  void packUnpackUint32() {
    var bytes = msgPackWrite(2147483648);
    var value = msgPackRead(bytes);
    expect(value, 2147483648);
  }

  void packUnpackInt8() {
    var bytes = msgPackWrite(-128);
    var value = msgPackRead(bytes);
    expect(value, -128);
  }

  void packUnpackInt16() {
    var bytes = msgPackWrite(-32768);
    var value = msgPackRead(bytes);
    expect(value, -32768);
  }

  void packUnpackInt32() {
    var bytes = msgPackWrite(-2147483648);
    var value = msgPackRead(bytes);
    expect(value, -2147483648);
  }

  void packUnpackDouble() {
    var bytes = msgPackWrite(3.14);
    var value = msgPackRead(bytes);
    expect(value, 3.14);
  }

  void packUnpackString5() {
    const data = 'hello';
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackString22() {
    const data = 'hello there, everyone!';
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackString256() {
    const data =
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackBin8() {
    var data = Uint8List.fromList(List.filled(32, 65));
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackBin16() {
    var data = Uint8List.fromList(List.filled(256, 65));
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackBin32() {
    var data = Uint8List.fromList(List.filled(65536, 65));
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackByteData() {
    var data = Uint8List.fromList(List.filled(32, 65));
    var bytes = msgPackWrite(ByteData.view(data.buffer));
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackIntArray() {
    const data = [
      1,
      2,
    ];
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackStringArray() {
    const data = ['one', 'two', 'three'];
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackLargeStringArray() {
    var data = <String>[];
    for (var i = 0; i < 16; ++i) {
      data.add('Item $i');
    }

    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackVeryLargeStringArray() {
    var data = <String>[];
    for (var i = 0; i < 65536; ++i) {
      data.add('Item $i');
    }

    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackIntToStringMap() {
    var data = {1: 'one', 2: 'two'};
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackLargeIntToStringMap() {
    var data = <int, String>{};
    for (var i = 0; i < 16; ++i) {
      data[i] = 'Item $i';
    }
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackVeryLargeIntToStringMap() {
    var data = <int, String>{};
    for (var i = 0; i < 65536; ++i) {
      data[i] = 'Item $i';
    }
    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  void packUnpackFixExt1() {
    var extensions = [FixExt1Extension()];
    var data = FixExt1(20);
    var bytes = msgPackWrite(data, extensions: extensions);
    var value = msgPackRead(bytes, extensions: extensions);
    expect(value, data);
  }

  void packUnpackDateTime() {
    var data = DateTime.now();

    var bytes = msgPackWrite(data);
    var value = msgPackRead(bytes);
    expect(value, data);
  }

  group('null', () {
    test('packUnpack', packUnpackNull);
  });

  group('bool', () {
    test('packUnpackFalse', packUnpackFalse);
    test('packUnpackTrue', packUnpackTrue);
  });

  group('int', () {
    test('packUnpackPositiveFixInt', packUnpackPositiveFixInt);
    test('packUnpackNegativeFixInt', packUnpackNegativeFixInt);
    test('packUnpackUint8', packUnpackUint8);
    test('packUnpackUint16', packUnpackUint16);
    test('packUnpackUint32', packUnpackUint32);
    test('packUnpackInt8', packUnpackInt8);
    test('packUnpackInt16', packUnpackInt16);
    test('packUnpackInt32', packUnpackInt32);
  });

  group('double', () {
    test('packUnpackDouble', packUnpackDouble);
  });

  group('string', () {
    test('packUnpackString5', packUnpackString5);
    test('packUnpackString22', packUnpackString22);
    test('packUnpackString256', packUnpackString256);
  });

  group('binary', () {
    test('packUnpackBin8', packUnpackBin8);
    test('packUnpackBin16', packUnpackBin16);
    test('packUnpackBin32', packUnpackBin32);
    test('packUnpackByteData', packUnpackByteData);
  });

  group('array', () {
    test('packUnpackIntArray', packUnpackIntArray);
    test('packUnpackStringArray', packUnpackStringArray);
    test('packUnpackLargeStringArray', packUnpackLargeStringArray);
    test('packUnpackVeryLargeStringArray', packUnpackVeryLargeStringArray);
  });

  group('map', () {
    test('packUnpackIntToStringMap', packUnpackIntToStringMap);
    test('packUnpackLargeIntToStringMap', packUnpackLargeIntToStringMap);
    test(
        'packUnpackVeryLargeIntToStringMap', packUnpackVeryLargeIntToStringMap);
  });

  group('ext', () {
    test('packUnpackFixExt1', packUnpackFixExt1);
  });

  group('Extensions', () {
    test('packUnpackDateTime', packUnpackDateTime);
  });
}
