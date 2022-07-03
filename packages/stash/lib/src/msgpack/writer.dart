import 'dart:typed_data';

import 'package:stash/src/api/codec/bytes_writer.dart';
import 'package:stash/src/msgpack/extension.dart';
import 'package:stash/src/msgpack/types.dart' as types;

/// Error thrown by MessagePack serialization if an object cannot be serialized.
///
/// The [unsupportedObject] field holds that object that failed to be serialized.
///
/// If an object isn't directly serializable, the serializer calls the `toJson`
/// method on the object. If that call fails, the error will be stored in the
/// [cause] field. If the call returns an object that isn't directly
/// serializable, the [cause] is null.
class MsgPackUnsupportedObjectError extends Error {
  /// The object that could not be serialized.
  final Object? unsupportedObject;

  /// The exception thrown when trying to convert the object.
  final Object? cause;

  /// Builds a [MsgPackUnsupportedObjectError]
  ///
  /// * [unsupportedObject]: The unsupported object
  /// * [cause]: The exception thrown
  MsgPackUnsupportedObjectError(this.unsupportedObject, {this.cause});

  @override
  String toString() {
    var safeString = Error.safeToString(unsupportedObject);
    String prefix;
    if (cause != null) {
      prefix = 'Converting object to an encodable object failed:';
    } else {
      prefix = 'Converting object did not return an encodable object:';
    }
    return '$prefix $safeString';
  }
}

/// Reports that an object could not be serialized due to cyclic references.
///
/// An object that references itself cannot be serialized.
/// When the cycle is detected, a [MsgPackCyclicError] is thrown.
class MsgPackCyclicError extends MsgPackUnsupportedObjectError {
  /// Builds a [MsgPackCyclicError]
  ///
  /// * [object]: The first object that was detected as part of a cycle.
  MsgPackCyclicError(super.object);
  @override
  String toString() => 'Cyclic error in JSON stringify';
}

/// Reports that an Object could not be serialized due to overflow error.
class MsgPackOverflowError extends MsgPackUnsupportedObjectError {
  /// Builds a [MsgPackOverflowError]
  ///
  /// * [object]: The object that cannot be serialized.
  MsgPackOverflowError(super.object);

  @override
  String toString() => 'Overflow error';
}

/// Implements a [msgpack](https://msgpack.org) serializer over the base [BytesWriter].
///
/// To support serialization of custom objects it relies on the definition a function on the target object
/// that provides a `Map<String, dynamic>` representation. Those methods can be automatically generated with
/// the [json_serializable](https://pub.dev/packages/json_serializable) dart package or similar. Per convention
/// it is assumed that there is a `toJson()` method on the target object. Note that what is serialized is
/// the [Map] representation of the object, therefore this transformation should be provided in some form.
class MsgPackWriter extends BytesWriter {
  // Implementation of the default encoder calls the toJson method to obtain a encodable representation of the object.
  static Map<String, dynamic> _defaultToEncodable(dynamic object) =>
      object.toJson();

  /// Function called on non-encodable objects to return a replacement
  /// encodable object that will be encoded in the orignal's place.
  final Map<String, dynamic> Function(dynamic) _toEncodable;

  /// The list of extensions
  final List<MsgPackExtension> _extensions;

  /// Builds a [MsgPackWriter] serializer.
  ///
  /// * [toEncodable]: A custom function the converts the object to a `Map<String, dynamic>` representation
  /// * [extensions]: A optional list of extensions to use
  MsgPackWriter(
      {Map<String, dynamic> Function(dynamic)? toEncodable,
      List<MsgPackExtension>? extensions})
      : _toEncodable = toEncodable ?? _defaultToEncodable,
        _extensions = [const DateTimeExtension(), ...?extensions];

  @override
  void writeNull() {
    writeUint8(types.nil);
  }

  @override
  void writeBool(bool b) {
    writeUint8(b ? types.boolTrue : types.boolFalse);
  }

  /// Writes a negative [int] [n] into the buffer
  ///
  /// * [n]: the value to write
  void _writeNegativeInt(int n) {
    if (n >= -32) {
      writeInt8(n);
    } else if (n >= -128) {
      writeUint8(types.int8);
      writeInt8(n);
    } else if (n >= -32768) {
      writeUint8(types.int16);
      writeInt16(n);
    } else if (n >= -2147483648) {
      writeUint8(types.int32);
      writeInt32(n);
    } else {
      writeUint8(types.int64);
      writeInt64(n);
    }
  }

  /// Writes a positive [int] [n] into the buffer
  ///
  /// * [n]: the value to write
  void _writePositiveInt(int n) {
    if (n <= 127) {
      writeUint8(n);
    } else if (n <= 0xFF) {
      writeUint8(types.uint8);
      writeUint8(n);
    } else if (n <= 0xFFFF) {
      writeUint8(types.uin16);
      writeUint16(n);
    } else if (n <= 0xFFFFFFFF) {
      writeUint8(types.uin32);
      writeUint32(n);
    } else {
      writeUint8(types.uin64);
      writeUint64(n);
    }
  }

  @override
  void writeInt(int n) {
    if (n >= 0) {
      _writePositiveInt(n);
    } else {
      _writeNegativeInt(n);
    }
  }

  @override
  void writeDouble(double n) {
    writeUint8(types.float64);
    writeFloat64(n);
  }

  @override
  void writeString(String s) {
    final encoded = encodeString(s);
    final length = encoded.length;
    if (length <= 31) {
      writeUint8(0xA0 | length);
    } else if (length <= 0xFF) {
      writeUint8(0xd9);
      writeUint8(length);
    } else if (length <= 0xFFFF) {
      writeUint8(0xda);
      writeUint16(length);
    } else if (length <= 0xFFFFFFFF) {
      writeUint8(0xdb);
      writeUint32(length);
    } else {
      throw MsgPackOverflowError(
          'String is too long to be serialized with msgpack.');
    }
    writeBytes(encoded);
  }

  @override
  void writeBinary(Uint8List buffer) {
    final length = buffer.length;
    if (length <= 0xFF) {
      writeUint8(types.bin8);
      writeUint8(length);
    } else if (length <= 0xFFFF) {
      writeUint8(types.bin16);
      writeUint16(length);
    } else if (length <= 0xFFFFFFFF) {
      writeUint8(types.bin32);
      writeUint32(length);
    } else {
      throw MsgPackOverflowError(
          'Data is too long to be serialized with msgpack.');
    }
    writeBytes(buffer);
  }

  @override
  void writeIterable(Iterable iterable) {
    final length = iterable.length;

    if (length <= 0xF) {
      writeUint8(0x90 | length);
    } else if (length <= 0xFFFF) {
      writeUint8(types.array16);
      writeUint16(length);
    } else if (length <= 0xFFFFFFFF) {
      writeUint8(types.array32);
      writeUint32(length);
    } else {
      throw MsgPackOverflowError(
          'Array is too big to be serialized with msgpack');
    }

    for (final item in iterable) {
      write(item);
    }
  }

  /// Writes the [Map] header to the buffer
  ///
  /// * [writer]: The [MsgPackWriter] to append data to
  /// * [map]: the [Map] to write
  void _writeMapHeader(MsgPackWriter writer, Map map) {
    final length = map.length;

    if (length <= 0xF) {
      writer.writeUint8(0x80 | length);
    } else if (length <= 0xFFFF) {
      writer.writeUint8(types.map16);
      writer.writeUint16(length);
    } else if (length <= 0xFFFFFFFF) {
      writer.writeUint8(types.map32);
      writer.writeUint32(length);
    } else {
      throw MsgPackOverflowError(
          'Map is too big to be serialized with msgpack');
    }
  }

  /// Writes the [Map] body to the buffer
  ///
  /// * [writer]: The [MsgPackWriter] to append data to
  /// * [map]: the [Map] to write
  void _writeMapBody(MsgPackWriter writer, Map map) {
    for (final item in map.entries) {
      writer.write(item.key);
      writer.write(item.value);
    }
  }

  @override
  void writeMap(Map map) {
    _writeMapHeader(this, map);
    _writeMapBody(this, map);
  }

  /// Writes the [type] extension to the buffer
  ///
  /// * [type]: The type code
  /// * [bytes]: The byte buffer to write
  void writeExt(int type, Uint8List bytes) {
    final length = bytes.length;
    if (length == 1) {
      writeUint8(types.fixext1);
    } else if (length == 2) {
      writeUint8(types.fixext2);
    } else if (length == 4) {
      writeUint8(types.fixext4);
    } else if (length == 8) {
      writeUint8(types.fixext8);
    } else if (length == 16) {
      writeUint8(types.fixext16);
    } else if (length <= 0xFF) {
      writeUint8(types.ext8);
      writeUint8(length);
    } else if (length <= 0xFFFF) {
      writeUint8(types.ext16);
      writeUint16(length);
    } else if (length <= 0xFFFFFFFF) {
      writeUint8(types.ext32);
      writeUint32(length);
    } else {
      throw MsgPackOverflowError('Size must be at most 0xFFFFFFFF');
    }

    writeUint8(type);
    writeBytes(bytes);
  }

  /// Writes a dynamic object to the buffer
  ///
  /// * [d]: The object to write
  ///
  /// Returns true if the object is supported and successfully written to the buffer false otherwise
  bool _writeObject(dynamic d) {
    if (d == null) {
      writeNull();
    } else if (d is bool) {
      writeBool(d);
    } else if (d is int) {
      writeInt(d);
    } else if (d is double) {
      writeDouble(d);
    } else if (d is String) {
      writeString(d);
    } else if (d is Uint8List) {
      writeBinary(d);
    } else if (d is Iterable) {
      writeIterable(d);
    } else if (d is ByteData) {
      writeByteData(d);
    } else if (d is Map) {
      writeMap(d);
    } else {
      for (var ext in _extensions) {
        if (ext.write(this, d)) {
          return true;
        }
      }

      return false;
    }

    return true;
  }

  /// Writes an encodable object to the buffer
  ///
  /// * [map]: The json encoded object to write
  void _writeEncodable(Map<String, dynamic> map) {
    var writer = MsgPackWriter();

    _writeMapHeader(writer, map);
    for (final item in map.entries) {
      writer.writeString(item.key);
      writer.write(item.value);
    }

    writeExt(0, writer.takeBytes());
  }

  @override
  void write(dynamic d) {
    if (!_writeObject(d)) {
      try {
        _writeEncodable(_toEncodable(d));
      } on NoSuchMethodError {
        throw MsgPackUnsupportedObjectError(d);
      }
    }
  }
}

/// Shortcut function to write a object to a [Uint8List] buffer
///
/// * [toEncodable]: A custom function that converts the object to a `Map<String, dynamic>` representation
/// * [extensions]: A optional list of extensions to use
///
/// Returns a [Uint8List] buffer with the object representation in bytes after successful serialization
Uint8List msgPackWrite(dynamic value,
    {Map<String, dynamic> Function(dynamic)? toEncodable,
    List<MsgPackExtension>? extensions}) {
  final writer =
      MsgPackWriter(toEncodable: toEncodable, extensions: extensions);
  writer.write(value);
  return writer.takeBytes();
}
