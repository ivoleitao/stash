import 'dart:typed_data';

import 'package:stash/src/api/cache_codec.dart';
import 'package:stash/src/api/codec/bytes_reader.dart';
import 'package:stash/src/api/codec/bytes_writer.dart';
import 'package:stash/src/api/codec/msgpack/extension.dart';
import 'package:stash/src/api/codec/msgpack/reader.dart';
import 'package:stash/src/api/codec/msgpack/writer.dart';

/// Msgpack binary codec implementation
class MsgpackCodec extends CacheCodec {
  /// The list of [MsgPackExtension] extensions to consider
  final List<MsgPackExtension> _extensions;

  /// Builds a [MsgpackCodec] with a optional list of extensions to consider
  ///
  /// * [_extensions]: Optional list of extensions
  const MsgpackCodec([this._extensions = const []]);

  @override
  BytesWriter encoder({Map<String, dynamic> Function(dynamic) toEncodable}) {
    return MsgPackWriter(toEncodable: toEncodable, extensions: _extensions);
  }

  @override
  BytesReader decoder(Uint8List bytes,
      {dynamic Function(Map<String, dynamic>) fromEncodable}) {
    return MsgPackReader(bytes,
        fromEncodable: fromEncodable, extensions: _extensions);
  }
}
