import 'dart:convert';
import 'dart:typed_data';

import 'package:stash/src/api/codec/bytes_util.dart';

/// Defines the base class supporting reads from a stream of bytes
abstract class BytesReader {
  /// Stores the initial list of bytes to read from
  final Uint8List _list;

  /// View over the list of bytes
  final ByteData _data;

  /// The String [Encoder]
  final Encoding _stringEncoder;

  /// The byte offset
  int _offset = 0;

  /// Builds a [BytesReader] from a byte list
  ///
  /// * [list]: The byte list
  /// * [stringEncoder]: The optional String encoder
  BytesReader(Uint8List list, {Encoding stringEncoder})
      : _list = list,
        _data = ByteData.view(list.buffer, list.offsetInBytes),
        _stringEncoder = stringEncoder ?? Utf8Codec();

  /// If false, decoded binary data buffers will reference underlying input
  /// buffer and thus may change when the content of input buffer changes.
  ///
  /// If true, decoded buffers are copies and the underlying input buffer is
  /// free to change after decoding.
  final bool copyBinaryData = false;

  /// Reads a uint8 from the backing buffer
  int readUInt8() {
    return _data.getUint8(_offset++);
  }

  /// Reads a int8 from the backing buffer
  int readInt8() {
    return _data.getInt8(_offset++);
  }

  /// Reads a uint16 from the backing buffer
  int readUInt16() {
    final res = _data.getUint16(_offset);
    _offset += uint16_size;
    return res;
  }

  /// Reads a int16 from the backing buffer
  int readInt16() {
    final res = _data.getInt16(_offset);
    _offset += int16_size;
    return res;
  }

  /// Reads a uint32 from the backing buffer
  int readUInt32() {
    final res = _data.getUint32(_offset);
    _offset += uint32_size;
    return res;
  }

  /// Reads a int32 from the backing buffer
  int readInt32() {
    final res = _data.getInt32(_offset);
    _offset += int32_size;
    return res;
  }

  /// Reads a uint64 from the backing buffer
  int readUInt64() {
    final res = _data.getUint64(_offset);
    _offset += uint64_size;
    return res;
  }

  /// Reads a int64 from the backing buffer
  int readInt64() {
    final res = _data.getInt64(_offset);
    _offset += int64_size;
    return res;
  }

  /// Reads a float32 from the backing buffer
  double readFloat32() {
    final res = _data.getFloat32(_offset);
    _offset += float32_size;
    return res;
  }

  /// Reads a float64 from the backing buffer
  double readFloat64() {
    final res = _data.getFloat64(_offset);
    _offset += float64_size;
    return res;
  }

  /// Reads a [Uint8List] from the backing buffer
  ///
  /// * [length]: The size
  Uint8List readBuffer(int length) {
    final res =
        Uint8List.view(_list.buffer, _list.offsetInBytes + _offset, length);
    _offset += length;
    return copyBinaryData ? Uint8List.fromList(res) : res;
  }

  /// Reads a String from the backing buffer
  ///
  /// * [length]: The number of bytes
  String readString(int length) {
    final list = readBuffer(length);
    final len = list.length;
    for (var i = 0; i < len; ++i) {
      if (list[i] > 127) {
        return _stringEncoder.decode(list);
      }
    }
    return String.fromCharCodes(list);
  }

  /// Reads a [List] from the backing buffer
  ///
  /// * [length]: The number of bytes
  List readArray(int length) {
    final res = List(length);
    for (var i = 0; i < length; ++i) {
      res[i] = read();
    }
    return res;
  }

  /// Reads a [Map] from the backing buffer
  ///
  /// * [length]: The number of bytes
  Map readMap(int length) {
    final res = {};
    while (length > 0) {
      res[read()] = read();
      --length;
    }
    return res;
  }

  dynamic read();
}
