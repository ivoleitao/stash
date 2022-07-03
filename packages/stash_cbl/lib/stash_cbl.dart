import 'dart:io';

import 'package:cbl/cbl.dart';
import 'package:stash/stash_api.dart';

import 'src/cbl/cbl_adapter.dart';
import 'src/cbl/cbl_store.dart';

export 'src/cbl/cbl_adapter.dart';
export 'src/cbl/cbl_store.dart';

/// Creates a new [CblVaultStore].
///
/// * [path]: The base storage location for this store.
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>`
///   representation to a binary representation.
/// * [async]: Whether to execute database operations asynchronously
///   on a background isolate, or synchronously on the main isolate.
/// * [encryptionKey]: The encryption key to use for encrypting databases.
Future<CblVaultStore> newCblLocalVaultStore({
  String? path,
  StoreCodec? codec,
  bool async = true,
  EncryptionKey? encryptionKey,
}) async {
  final adapter = await CblAdapter.build(
    path ?? Directory.systemTemp.path,
    async: async,
    encryptionKey: encryptionKey,
  );
  return CblVaultStore(adapter, codec: codec);
}

/// Creates a new [CblCacheStore].
///
/// * [path]: The base storage location for this store.
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>`
///   representation to a binary representation.
/// * [async]: Whether to execute database operations asynchronously
///   on a background isolate, or synchronously on the main isolate.
/// * [encryptionKey]: The encryption key to use for encrypting databases.
Future<CblCacheStore> newCblLocalCacheStore({
  String? path,
  StoreCodec? codec,
  bool async = true,
  EncryptionKey? encryptionKey,
}) async {
  final adapter = await CblAdapter.build(
    path ?? Directory.systemTemp.path,
    async: async,
    encryptionKey: encryptionKey,
  );
  return CblCacheStore(adapter, codec: codec);
}
