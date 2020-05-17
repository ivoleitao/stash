import 'dart:typed_data';

/// Builds a list of bytes, allowing bytes and lists of bytes to be added at the
/// end.
///
/// Used to efficiently collect bytes and lists of bytes.
abstract class BytesBuilder {
  /// Construct a new empty [BytesBuilder].
  ///
  /// * [copy]: The data is copied if true, false otherwise. Defaults to true
  ///
  /// If [copy] is true, the data is always copied when added to the list. If
  /// it [copy] is false, the data is only copied if needed. That means that if
  /// the lists are changed after added to the [BytesBuilder], it may effect the
  /// output. Default is `true`.
  factory BytesBuilder({bool copy = true}) {
    if (copy) {
      return _CopyingBytesBuilder();
    } else {
      return _BytesBuilder();
    }
  }

  /// Appends [bytes] to the current contents of the builder.
  ///
  /// * [bytes]: The bytes to add
  ///
  /// Each value of [bytes] will be bit-representation truncated to the range
  /// 0 .. 255.
  void add(List<int> bytes);

  /// Append [byte] to the current contents of the builder.
  ///
  /// * [byte]: The byte to add
  ///
  /// The [byte] will be bit-representation truncated to the range 0 .. 255.
  void addByte(int byte);

  /// Returns the contents of `this` and clears `this`.
  ///
  /// The list returned is a view of the internal buffer, limited to the
  /// [length].
  Uint8List takeBytes();

  /// Returns a copy of the current contents of the builder.
  ///
  /// Leaves the contents of the builder intact.
  Uint8List toBytes();

  /// The number of bytes in the builder.
  int get length;

  /// Returns `true` if the buffer is empty.
  bool get isEmpty;

  /// Returns `true` if the buffer is not empty.
  bool get isNotEmpty;

  /// Clear the contents of the builder.
  void clear();
}

/// A [BytesBuilder] that copies the contents of the buffer
class _CopyingBytesBuilder implements BytesBuilder {
  // Start with 1024 bytes.
  static const int _initSize = 1024;

  // Safe for reuse because a fixed-length empty list is immutable.
  static final _emptyList = Uint8List(0);

  /// The length
  int _length = 0;

  /// The base buffer
  Uint8List _buffer;

  /// Builds a [_CopyingBytesBuilder] optionally configuring the initial capacity
  ///
  /// * [initialCapacity]: The initial capacity of the buffer, defaults to 0
  _CopyingBytesBuilder([int initialCapacity = 0])
      : _buffer = (initialCapacity <= 0)
            ? _emptyList
            : Uint8List(_pow2roundup(initialCapacity));

  @override
  void add(List<int> bytes) {
    var bytesLength = bytes.length;
    if (bytesLength == 0) return;
    var required = _length + bytesLength;
    if (_buffer.length < required) {
      _grow(required);
    }
    assert(_buffer.length >= required);
    if (bytes is Uint8List) {
      _buffer.setRange(_length, required, bytes);
    } else {
      for (var i = 0; i < bytesLength; i++) {
        _buffer[_length + i] = bytes[i];
      }
    }
    _length = required;
  }

  @override
  void addByte(int byte) {
    if (_buffer.length == _length) {
      // The grow algorithm always at least doubles.
      // If we added one to _length it would quadruple unnecessarily.
      _grow(_length);
    }
    assert(_buffer.length > _length);
    _buffer[_length] = byte;
    _length++;
  }

  /// Grows the buffer by the required [length] amount
  ///
  /// * [length]: The buffer length increase
  void _grow(int length) {
    // We will create a list in the range of 2-4 times larger than
    // required.
    var newSize = length * 2;
    if (newSize < _initSize) {
      newSize = _initSize;
    } else {
      newSize = _pow2roundup(newSize);
    }
    var newBuffer = Uint8List(newSize);
    newBuffer.setRange(0, _buffer.length, _buffer);
    _buffer = newBuffer;
  }

  @override
  Uint8List takeBytes() {
    if (_length == 0) return _emptyList;
    var buffer = Uint8List.view(_buffer.buffer, _buffer.offsetInBytes, _length);
    clear();
    return buffer;
  }

  @override
  Uint8List toBytes() {
    if (_length == 0) return _emptyList;
    return Uint8List.fromList(
        Uint8List.view(_buffer.buffer, _buffer.offsetInBytes, _length));
  }

  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length != 0;

  @override
  void clear() {
    _length = 0;
    _buffer = _emptyList;
  }

  /// Calculates the pow2 of [x]
  ///
  /// * [x]: The value to use
  ///
  /// Returns the pow2 of [x]
  static int _pow2roundup(int x) {
    assert(x > 0);
    --x;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x + 1;
  }
}

/// The default implementation of [BytesBuilder]
class _BytesBuilder implements BytesBuilder {
  /// The length
  int _length = 0;

  /// The chunk list
  final List<Uint8List> _chunks = [];

  @override
  void add(List<int> bytes) {
    Uint8List typedBytes;
    if (bytes is Uint8List) {
      typedBytes = bytes;
    } else {
      typedBytes = Uint8List.fromList(bytes);
    }
    _chunks.add(typedBytes);
    _length += typedBytes.length;
  }

  @override
  void addByte(int byte) {
    _chunks.add(Uint8List(1)..[0] = byte);
    _length++;
  }

  @override
  Uint8List takeBytes() {
    if (_length == 0) return _CopyingBytesBuilder._emptyList;
    if (_chunks.length == 1) {
      var buffer = _chunks[0];
      clear();
      return buffer;
    }
    var buffer = Uint8List(_length);
    var offset = 0;
    for (var chunk in _chunks) {
      buffer.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    clear();
    return buffer;
  }

  @override
  Uint8List toBytes() {
    if (_length == 0) return _CopyingBytesBuilder._emptyList;
    var buffer = Uint8List(_length);
    var offset = 0;
    for (var chunk in _chunks) {
      buffer.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return buffer;
  }

  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length != 0;

  @override
  void clear() {
    _length = 0;
    _chunks.clear();
  }
}
