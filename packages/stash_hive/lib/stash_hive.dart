/// Provides a Hive implementation of the Stash caching API for Dart
library stash_hive;

import 'package:hive/hive.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_hive/src/hive/hive_adapter.dart';
import 'package:stash_hive/src/hive/hive_store.dart';

export 'src/hive/hive_adapter.dart';
export 'src/hive/hive_store.dart';

/// Creates a new [HiveDefaultVaultStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
Future<HiveDefaultVaultStore> newHiveDefaultVaultStore(
    {String? path,
    StoreCodec? codec,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultAdapter.build(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery)
      .then((adapter) => HiveDefaultVaultStore(adapter, codec: codec));
}

/// Creates a new [HiveDefaultCacheStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
Future<HiveDefaultCacheStore> newHiveDefaultCacheStore(
    {String? path,
    StoreCodec? codec,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultAdapter.build(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery)
      .then((adapter) => HiveDefaultCacheStore(adapter, codec: codec));
}

/// Creates a new [HiveLazyVaultStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
Future<HiveLazyVaultStore> newHiveLazyVaultStore(
    {String? path,
    StoreCodec? codec,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyAdapter.build(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery)
      .then((adapter) => HiveLazyVaultStore(adapter, codec: codec));
}

/// Creates a new [HiveLazyCacheStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
Future<HiveLazyCacheStore> newHiveLazyCacheStore(
    {String? path,
    StoreCodec? codec,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyAdapter.build(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery)
      .then((adapter) => HiveLazyCacheStore(adapter, codec: codec));
}
