import 'dart:typed_data';

import 'package:stash/src/api/codec/msgpack/reader.dart';
import 'package:stash/src/api/codec/msgpack/writer.dart';

/// Base definition of a extension. It's purpose is to support custom objects directly without them needing to
/// provide a method to serialize/deserialize to/from a Map. This mechanism is mostly target to some base types
/// of the Dart language
abstract class MsgPackExtension {
  /// The type code
  final int type;

  /// Builds [MsgPackExtension] with the specified [type] code
  const MsgPackExtension(this.type) : assert(type > 0);

  /// Writes the [object] to the provided [MsgPackWriter] [writer]
  ///
  /// * [writer]: The [MsgPackWriter] to use to serialize the object
  /// * [object]: The target object
  ///
  /// Returns true if the object is serializable via the current extension, false otherwise
  bool doWrite(MsgPackWriter writer, dynamic object);

  /// Appends to a [MsgPackWriter] provided [writer] the [object] as a extension.
  ///
  /// * [writer]: The base [MsgPackWriter] used in the main object serialization process
  /// * [object]: The target object
  ///
  /// Returns true if the object is serializable via the current extension, false otherwise
  bool write(MsgPackWriter writer, dynamic object) {
    var extWriter = MsgPackWriter();

    if (doWrite(extWriter, object)) {
      writer.writeExt(type, extWriter.takeBytes());

      return true;
    }

    return false;
  }

  /// Reads the serialized representation of an object
  ///
  /// * [reader]: The [MsgPackReader] that should be used to read the object extension
  ///
  /// Returns the object after successful deserialization
  dynamic doRead(MsgPackReader reader);

  /// Tries to read [targetType] code using the current extension
  ///
  /// * [targetType]: The type code to read
  /// * [bytes]: The byte buffer to use to read the object
  ///
  /// Returns null if the [targetType] is not supported by this extension
  dynamic read(int targetType, Uint8List bytes) {
    if (targetType == type) {
      return doRead(MsgPackReader(bytes));
    }

    return null;
  }
}

/// Datetime extension for msgpack
class DateTimeExtension extends MsgPackExtension {
  /// Datetime type code
  static const int DatetimeType = 1;

  /// Builds a [DateTimeExtension] with type code equal to [DatetimeType]
  const DateTimeExtension() : super(DatetimeType);

  @override
  bool doWrite(MsgPackWriter writer, dynamic object) {
    if (object is DateTime) {
      writer.writeString(object.toIso8601String());

      return true;
    }

    return false;
  }

  @override
  dynamic doRead(MsgPackReader reader) {
    return DateTime.parse(reader.read());
  }
}
