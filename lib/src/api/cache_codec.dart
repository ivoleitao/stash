import 'dart:typed_data';

import 'package:stash/src/api/codec/bytes_reader.dart';
import 'package:stash/src/api/codec/bytes_writer.dart';

/// Defines the contract of a binary codec that should be used for the serialization / deserealization of a value
abstract class CacheCodec {
  /// Builds a [CacheCodec]
  const CacheCodec();

  /// Returns a [BytesWriter] implementation that will handle the serialization
  ///
  /// * [toEncodable]: An optional function to convert an object into a json map
  BytesWriter encoder({Map<String, dynamic> Function(dynamic) toEncodable});

  /// Returns a [BytesReader] implementation that will handle the deserialization
  ///
  /// * [bytes]: The bytes to deserialize
  /// * [fromEncodable]: An optional function to convert a json map into a object
  BytesReader decoder(Uint8List bytes,
      {dynamic Function(Map<String, dynamic>) fromEncodable});
}
