/// Provides a Hive implementation of the Stash caching API for Dart
library stash_hive;

import 'package:hive/hive.dart';
import 'package:stash_hive/src/hive/hive_adapter.dart';
import 'package:stash_hive/src/hive/hive_store.dart';

export 'package:stash/stash_api.dart';

export 'src/hive/hive_adapter.dart';
export 'src/hive/hive_store.dart';

/// Creates a new [HiveDefaultVaultStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveDefaultVaultStore newHiveDefaultVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultVaultStore(
      HiveDefaultAdapter(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveDefaultCacheStore]
///
/// * [path]: The base storage location for this store, the current directoy if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveDefaultCacheStore newHiveDefaultCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveDefaultCacheStore(
      HiveDefaultAdapter(
          path: path ?? '.',
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveLazyVaultStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveLazyVaultStore newHiveLazyVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyVaultStore(
      HiveLazyAdapter(path ?? '.',
          encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}

/// Creates a new [HiveLazyCacheStore]
///
/// * [path]: The base storage location for this store, the current directory if not provided
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [encryptionCipher]: The encryption cypher
/// * [crashRecovery]: If it supports crash recovery
HiveLazyCacheStore newHiveLazyCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    HiveCipher? encryptionCipher,
    bool? crashRecovery}) {
  return HiveLazyCacheStore(
      HiveLazyAdapter(path ?? '.',
          encryptionCipher: encryptionCipher, crashRecovery: crashRecovery),
      fromEncodable: fromEncodable);
}
