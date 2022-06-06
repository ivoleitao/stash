/// Provides a Sembast implementation of the Stash caching API for Dart
library stash_sembast;

import 'package:sembast/sembast.dart';
import 'package:stash_sembast/src/sembast/sembast_adapter.dart';
import 'package:stash_sembast/src/sembast/sembast_store.dart';

export 'src/sembast/sembast_adapter.dart';
export 'src/sembast/sembast_store.dart';

/// Creates a new in-memory [SembastVaultStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastVaultStore> newSembastMemoryVaultStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastMemoryAdapter.build('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastVaultStore(adapter, fromEncodable: fromEncodable));
}

/// Creates a new in-memory [SembastCacheStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastCacheStore> newSembastMemoryCacheStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastMemoryAdapter.build('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastCacheStore(adapter, fromEncodable: fromEncodable));
}

/// Creates a new [SembastVaultStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastVaultStore> newSembastLocalVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastLocalAdapter.build(path ?? 'vault.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastVaultStore(adapter, fromEncodable: fromEncodable));
}

/// Creates a new [SembastCacheStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastCacheStore> newSembastLocalCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastLocalAdapter.build(path ?? 'cache.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastCacheStore(adapter, fromEncodable: fromEncodable));
}
