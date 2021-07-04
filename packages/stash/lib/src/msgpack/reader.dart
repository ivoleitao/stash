import 'dart:typed_data';

import 'package:stash/src/api/codec/bytes_reader.dart';
import 'package:stash/src/msgpack/extension.dart';
import 'package:stash/src/msgpack/types.dart' as types;

/// Error thrown by MessagePack serialization if an object cannot be deserialized.
///
/// The [unsupportedType] field holds that object that failed to be deserialized.
class MsgPackUnsupportedTypeError extends Error {
  /// The type that could not be deserialized.
  final int unsupportedType;

  /// The exception thrown when trying to deserialize the type.
  final Object? cause;

  /// Builds a [MsgPackUnsupportedTypeError] object
  ///
  /// * [unsupportedType]: The unsupported type
  /// * [cause]: The exception thrown
  MsgPackUnsupportedTypeError(this.unsupportedType, {this.cause});

  @override
  String toString() {
    var safeString = Error.safeToString(unsupportedType);
    String prefix;
    if (cause != null) {
      prefix = 'Deserializing object failed:';
    } else {
      prefix = 'Unsoported type:';
    }
    return '$prefix $safeString';
  }
}

/// Implements a [msgpack](https://msgpack.org) deserializer over a base [BytesReader]
///
/// To support deserialization of custom objects it relies on the definition a function
/// that is able to use `Map<String, dynamic>` representation and generate the appropriate object out of it.
/// Those methods can be automatically generated with the [json_serializable](https://pub.dev/packages/json_serializable)
/// dart package or similar. Note that what is deserialized is the [Map] representation of the object,
/// therefore this method should be provided in some form.
class MsgPackReader extends BytesReader {
  // Implementation of the default decoder returns the Map<String, dynamic> without trying to convert it to a proper object
  static dynamic _defaultFromEncodable(Map<String, dynamic> encodable) =>
      encodable;

  /// Function called on encodable object to obtain the underlining type
  final dynamic Function(Map<String, dynamic>) _fromEncodable;

  /// The list of extensions
  final List<MsgPackExtension> _extensions;

  /// Builds a [MsgPackReader] deserializer
  ///
  /// * [list]: The [Uint8List] byte buffer to read the object from
  /// * [fromEncodable]: A custom function the converts the deserialized `Map<String, dynamic>` representation of the object into the object
  /// * [extensions]: A optional list of extensions to use
  MsgPackReader(Uint8List list,
      {dynamic Function(Map<String, dynamic>)? fromEncodable,
      List<MsgPackExtension>? extensions})
      : _fromEncodable = fromEncodable ?? _defaultFromEncodable,
        _extensions = [const DateTimeExtension(), ...?extensions],
        super(list);

  /// Reads the [String] key of the encodable [Map] representation of the object
  ///
  /// Returns the key
  String _readEncodableKey() {
    final u = readUInt8();

    if ((u & 0xE0) == 0xA0) {
      return readString(u & 0x1F);
    } else if (u == types.str8) {
      return readString(readUInt8());
    } else if (u == types.str16) {
      return readString(readUInt16());
    }

    throw MsgPackUnsupportedTypeError(u);
  }

  /// Reads the encodable representation of the object
  ///
  /// * [length]: The length of the encodable representation
  ///
  /// Returns the Map<String, dynamic> representation of the encoded object
  Map<String, dynamic> _readEncodable(int length) {
    final res = <String, dynamic>{};
    while (length > 0) {
      res[_readEncodableKey()] = read();
      length--;
    }
    return res;
  }

  /// Reads the encodable representation of the object
  ///
  /// Returns the Map<String, dynamic> representation of the encoded object
  Map<String, dynamic> readEncodable() {
    final u = readUInt8();

    if ((u & 0xF0) == 0x80) {
      return _readEncodable(u & 0xF);
    } else if (u == types.map16) {
      return _readEncodable(readUInt16());
    } else if (u == types.map32) {
      return _readEncodable(readUInt32());
    }

    throw MsgPackUnsupportedTypeError(u);
  }

  /// Reads a extension object from the byte buffer
  ///
  /// * [length]: The length of the extension object
  ///
  /// Returns the object provided through a extension
  dynamic _readExt(int length) {
    final type = readUInt8();
    final bytes = readBuffer(length);

    if (type == 0) {
      var reader = MsgPackReader(bytes);
      return _fromEncodable(reader.readEncodable());
    }

    for (var ext in _extensions) {
      var value = ext.read(type, bytes);
      if (value != null) {
        return value;
      }
    }

    return null;
  }

  @override
  dynamic read() {
    final u = readUInt8();
    if (u <= 127) {
      return u;
    } else if ((u & 0xE0) == 0xE0) {
      // negative small integer
      return u - 256;
    } else if ((u & 0xE0) == 0xA0) {
      return readString(u & 0x1F);
    } else if ((u & 0xF0) == 0x90) {
      return readArray(u & 0xF);
    } else if ((u & 0xF0) == 0x80) {
      return readMap(u & 0xF);
    }
    switch (u) {
      case types.nil:
        return null;
      case types.boolFalse:
        return false;
      case types.boolTrue:
        return true;
      case types.bin8:
        return readBuffer(readUInt8());
      case types.bin16:
        return readBuffer(readUInt16());
      case types.bin32:
        return readBuffer(readUInt32());
      case types.ext8:
        return _readExt(readUInt8());
      case types.ext16:
        return _readExt(readUInt16());
      case types.ext32:
        return _readExt(readUInt32());
      case types.float32:
        return readFloat32();
      case types.float64:
        return readFloat64();
      case types.uint8:
        return readUInt8();
      case types.uin16:
        return readUInt16();
      case types.uin32:
        return readUInt32();
      case types.uin64:
        return readUInt64();
      case types.int8:
        return readInt8();
      case types.int16:
        return readInt16();
      case types.int32:
        return readInt32();
      case types.int64:
        return readInt64();
      case types.fixext1:
        return _readExt(1);
      case types.fixext2:
        return _readExt(2);
      case types.fixext4:
        return _readExt(4);
      case types.fixext8:
        return _readExt(8);
      case types.fixext16:
        return _readExt(16);
      case types.str8:
        return readString(readUInt8());
      case types.str16:
        return readString(readUInt16());
      case types.str32:
        return readString(readUInt32());
      case types.array16:
        return readArray(readUInt16());
      case types.array32:
        return readArray(readUInt32());
      case types.map16:
        return readMap(readUInt16());
      case types.map32:
        return readMap(readUInt32());
      default:
        throw MsgPackUnsupportedTypeError(u);
    }
  }
}

/// Shortcut function to read a object from a [Uint8List] buffer
///
/// * [bytes]: The [Uint8List] byte buffer to read from
/// * [fromEncodable]: A custom function the converts the deserialized `Map<String, dynamic>` representation of the object into the object
/// * [extensions]: A optional list of extensions to use
///
/// Returns the underlying object after successful deserialization
dynamic msgPackRead(Uint8List bytes,
    {dynamic Function(dynamic)? fromEncodable,
    List<MsgPackExtension>? extensions}) {
  final reader = MsgPackReader(bytes,
      fromEncodable: fromEncodable, extensions: extensions);
  return reader.read();
}
