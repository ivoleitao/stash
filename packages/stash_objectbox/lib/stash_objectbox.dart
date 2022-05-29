/// Provides a Objectbox implementation of the Stash caching API for Dart
library stash_objectbox;

import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_adapter.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_store.dart';

export 'src/objectbox/objectbox_adapter.dart';
export 'src/objectbox/objectbox_store.dart';

/// Creates a new [ObjectboxVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
Future<ObjectboxVaultStore> newObjectboxLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return ObjectboxAdapter.build(path ?? Directory.systemTemp.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault)
      .then((adapter) => ObjectboxVaultStore(adapter,
          codec: codec, fromEncodable: fromEncodable));
}

/// Creates a new [ObjectboxCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
Future<ObjectboxCacheStore> newObjectboxLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return ObjectboxAdapter.build(path ?? Directory.systemTemp.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault)
      .then((adapter) => ObjectboxCacheStore(adapter,
          codec: codec, fromEncodable: fromEncodable));
}
