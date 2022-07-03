/// Provides a Isar implementation of the Stash caching API for Dart
library stash_isar;

import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_isar/src/isar/isar_adapter.dart';
import 'package:stash_isar/src/isar/isar_store.dart';

export 'src/isar/isar_adapter.dart';
export 'src/isar/isar_store.dart';

/// Creates a new [IsarVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [relaxedDurability]: Relaxed durability setting
/// * [inspector]: Inspector setting
Future<IsarVaultStore> newIsarLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    bool? relaxedDurability,
    bool? inspector}) {
  return IsarVaultAdapter.build(
          path: path ?? Directory.systemTemp.path,
          relaxedDurability: relaxedDurability,
          inspector: inspector)
      .then((adapter) => IsarVaultStore(adapter, codec: codec));
}

/// Creates a new [IsarCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [relaxedDurability]: Relaxed durability setting
/// * [inspector]: Inspector setting
Future<IsarCacheStore> newIsarLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    bool? relaxedDurability,
    bool? inspector}) {
  return IsarCacheAdapter.build(
          path: path ?? Directory.systemTemp.path,
          relaxedDurability: relaxedDurability,
          inspector: inspector)
      .then((adapter) => IsarCacheStore(adapter, codec: codec));
}
