import 'dart:convert';
import 'dart:typed_data';

import 'package:stash/src/api/codec/bytes_builder.dart';
import 'package:stash/src/api/codec/bytes_util.dart';

/// Defines the base class supporting writes to a stream of bytes
abstract class BytesWriter {
  /// The initial scratch buffer size
  final int _kScratchSizeInitial = 64;

  /// The regular buffer size
  final int _kScratchSizeRegular = 1024;

  /// The builder
  final BytesBuilder _builder = BytesBuilder(copy: false);

  /// The string encoder to use
  final Encoding _stringEncoder;

  /// The scratch buffer
  Uint8List _scratchBuffer;

  /// A view of the buffer
  ByteData _scratchData;

  /// The buffer offset
  int _scratchOffset = 0;

  /// Builds a new [BytesWriter]
  ///
  /// * [stringEncoder]: A optional string encoder, defaults to [Utf8Codec]
  BytesWriter({Encoding stringEncoder})
      : _stringEncoder = stringEncoder ?? Utf8Codec();

  /// Increases the scratch buffer
  void _appendScratchBuffer() {
    if (_scratchOffset > 0) {
      if (_builder.isEmpty) {
        // We're still on small scratch buffer, move it to _builder
        // and create regular one
        _builder.add(Uint8List.view(
          _scratchBuffer.buffer,
          _scratchBuffer.offsetInBytes,
          _scratchOffset,
        ));
        _scratchBuffer = Uint8List(_kScratchSizeRegular);
        _scratchData =
            ByteData.view(_scratchBuffer.buffer, _scratchBuffer.offsetInBytes);
      } else {
        _builder.add(
          Uint8List.fromList(
            Uint8List.view(
              _scratchBuffer.buffer,
              _scratchBuffer.offsetInBytes,
              _scratchOffset,
            ),
          ),
        );
      }
      _scratchOffset = 0;
    }
  }

  /// Checks if there is enough room to fit the provided [size]
  ///
  /// * [size]: The desired increase in size
  void _ensureSize(int size) {
    if (_scratchBuffer == null) {
      // start with small scratch buffer, expand to regular later if needed
      _scratchBuffer = Uint8List(_kScratchSizeInitial);
      _scratchData =
          ByteData.view(_scratchBuffer.buffer, _scratchBuffer.offsetInBytes);
    }
    final remaining = _scratchBuffer.length - _scratchOffset;
    if (remaining < size) {
      _appendScratchBuffer();
    }
  }

  /// Writes a Uint8 [i] into the buffer
  ///
  /// * [i]: The value to write
  void writeUint8(int i) {
    _ensureSize(uint8_size);
    _scratchData.setUint8(_scratchOffset, i);
    _scratchOffset += uint8_size;
  }

  /// Writes a int8 [i] into the buffer
  ///
  /// * [i]: The value to write
  void writeInt8(int i) {
    _ensureSize(int8_size);
    _scratchData.setInt8(_scratchOffset, i);
    _scratchOffset += int8_size;
  }

  /// Writes a uint16 [i] into the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeUint16(int i, [Endian endian = Endian.big]) {
    _ensureSize(uint16_size);
    _scratchData.setUint16(_scratchOffset, i, endian);
    _scratchOffset += uint16_size;
  }

  /// Writes a int16 [i] in the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeInt16(int i, [Endian endian = Endian.big]) {
    _ensureSize(int16_size);
    _scratchData.setInt16(_scratchOffset, i, endian);
    _scratchOffset += int16_size;
  }

  /// Writes a uint32 [i] into the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeUint32(int i, [Endian endian = Endian.big]) {
    _ensureSize(uint32_size);
    _scratchData.setUint32(_scratchOffset, i, endian);
    _scratchOffset += uint32_size;
  }

  /// Writes a int32 [i] into the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeInt32(int i, [Endian endian = Endian.big]) {
    _ensureSize(int32_size);
    _scratchData.setInt32(_scratchOffset, i, endian);
    _scratchOffset += int32_size;
  }

  /// Writes a uint64 [i] into the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeUint64(int i, [Endian endian = Endian.big]) {
    _ensureSize(uint64_size);
    _scratchData.setUint64(_scratchOffset, i, endian);
    _scratchOffset += uint64_size;
  }

  /// Writes a int64 [i] into the buffer
  ///
  /// * [i]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeInt64(int i, [Endian endian = Endian.big]) {
    _ensureSize(int64_size);
    _scratchData.setInt64(_scratchOffset, i, endian);
    _scratchOffset += int64_size;
  }

  /// Writes a float32 [f] into the buffer
  ///
  /// * [f]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeFloat32(double f, [Endian endian = Endian.big]) {
    _ensureSize(float32_size);
    _scratchData.setFloat32(_scratchOffset, f, endian);
    _scratchOffset += float32_size;
  }

  /// Writes a float64 [d] into the buffer
  ///
  /// * [d]: The value to write
  /// * [endian]: The endianess, [Endian.big] by default
  void writeFloat64(double d, [Endian endian = Endian.big]) {
    _ensureSize(float64_size);
    _scratchData.setFloat64(_scratchOffset, d, endian);
    _scratchOffset += float64_size;
  }

  /// Writes a list of bytes
  ///
  /// * [bytes]: The list of bytes
  ///
  /// Note: The list may be retained until takeBytes is called
  void writeBytes(List<int> bytes) {
    final length = bytes.length;
    if (length == 0) {
      return;
    }
    _ensureSize(length);
    if (_scratchOffset == 0) {
      // we can add it directly
      _builder.add(bytes);
    } else {
      // there is enough room in _scratchBuffer, otherwise _ensureSize
      // would have added _scratchBuffer to _builder and _scratchOffset would
      // be 0
      if (bytes is Uint8List) {
        _scratchBuffer.setRange(_scratchOffset, _scratchOffset + length, bytes);
      } else {
        for (var i = 0; i < length; i++) {
          _scratchBuffer[_scratchOffset + i] = bytes[i];
        }
      }
      _scratchOffset += length;
    }
  }

  /// Writes a buffer of bytes
  ///
  /// * [buffer]: The buffer of bytes
  void writeByteData(ByteData buffer) {
    writeBinary(
        buffer.buffer.asUint8List(buffer.offsetInBytes, buffer.lengthInBytes));
  }

  /// Encodes a String [s] with the configured [Encoding]
  ///
  /// * [s]: The String to encode
  ///
  /// Returns the encoded String as list of bytes
  List<int> encodeString(String s) {
    return _stringEncoder.encode(s);
  }

  /// Writes null
  void writeNull();

  /// Writes bool [b] into the buffer
  ///
  /// * [b]: the value to write
  void writeBool(bool b);

  /// Writes int [n] into the buffer
  ///
  /// * [n]: the value to write
  void writeInt(int n);

  /// Writes double [n] into the buffer
  ///
  /// * [n]: the value to write
  void writeDouble(double n);

  /// Writes a String [s] into the buffer
  ///
  /// * [s]: the value to write
  void writeString(String s);

  /// Writes a [Uint8List] into the buffer
  ///
  /// * [buffer]: the value to write
  void writeBinary(Uint8List buffer);

  /// Writes a [Iterable] into the buffer
  ///
  /// * [iterable]: the value to write
  void writeIterable(Iterable iterable);

  /// Writes a [Map] into the buffer
  ///
  /// * [map]: the value to write
  void writeMap(Map map);

  /// Writes a dynamic value into the buffer
  ///
  /// * [d]: the value to write
  void write(dynamic d);

  /// Takes the list of bytes from the buffer as a [Uint8List]
  ///
  /// Returns the final list of bytes
  Uint8List takeBytes() {
    if (_builder.isEmpty) {
      // Just take scratch data
      final res = Uint8List.view(
        _scratchBuffer.buffer,
        _scratchBuffer.offsetInBytes,
        _scratchOffset,
      );
      _scratchOffset = 0;
      _scratchBuffer = null;
      _scratchData = null;
      return res;
    } else {
      _appendScratchBuffer();
      return _builder.takeBytes();
    }
  }
}
