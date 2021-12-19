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
SembastVaultStore newSembastMemoryVaultStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastVaultStore(
      SembastMemoryAdapter('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}

/// Creates a new in-memory [SembastCacheStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
SembastCacheStore newSembastMemoryCacheStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastCacheStore(
      SembastMemoryAdapter('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}

/// Creates a new [SembastVaultStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
SembastVaultStore newSembastLocalVaultStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastVaultStore(
      SembastPathAdapter(path ?? 'stash_sembast.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}

/// Creates a new [SembastCacheStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
SembastCacheStore newSembastLocalCacheStore(
    {String? path,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastCacheStore(
      SembastPathAdapter(path ?? 'stash_sembast.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec),
      fromEncodable: fromEncodable);
}
