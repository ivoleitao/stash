/// Provides a Isar implementation of the Stash caching API for Dart
library stash_isar;

import 'dart:io';

import 'package:isar/isar.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_isar/src/isar/isar_adapter.dart';
import 'package:stash_isar/src/isar/isar_store.dart';

export 'src/isar/isar_adapter.dart';
export 'src/isar/isar_store.dart';

/// Creates a new [IsarVaultStore]
///
/// * [path]: The base location of the Isar partition
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [maxSizeMib]: The max size Mib
/// * [relaxedDurability]: Relaxed durability setting
/// * [compactOnLaunch]: The condition for the db to be compacted on launch
/// * [inspector]: If the inspector is enabled
Future<IsarVaultStore> newIsarLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    int? maxSizeMib,
    bool? relaxedDurability,
    CompactCondition? compactOnLaunch,
    bool? inspector}) {
  return IsarVaultAdapter.build(path ?? Directory.systemTemp.path,
          maxSizeMib: maxSizeMib,
          relaxedDurability: relaxedDurability,
          compactOnLaunch: compactOnLaunch,
          inspector: inspector)
      .then((adapter) => IsarVaultStore(adapter, codec: codec));
}

/// Creates a new [IsarCacheStore]
///
/// * [path]: The base location of the Isar partition
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [maxSizeMib]: The max size Mib
/// * [relaxedDurability]: Relaxed durability setting
/// * [compactOnLaunch]: The condition for the db to be compacted on launch
/// * [inspector]: If the inspector is enabled
Future<IsarCacheStore> newIsarLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    int? maxSizeMib,
    bool? relaxedDurability,
    CompactCondition? compactOnLaunch,
    bool? inspector}) {
  return IsarCacheAdapter.build(path ?? Directory.systemTemp.path,
          maxSizeMib: maxSizeMib,
          relaxedDurability: relaxedDurability,
          compactOnLaunch: compactOnLaunch,
          inspector: inspector)
      .then((adapter) => IsarCacheStore(adapter, codec: codec));
}
