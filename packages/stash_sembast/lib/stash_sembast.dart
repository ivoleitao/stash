/// Provides a Sembast implementation of the Stash caching API for Dart
library stash_sembast;

import 'package:sembast/sembast.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_adapter.dart';
import 'package:stash_sembast/src/sembast/sembast_store.dart';

export 'src/sembast/sembast_adapter.dart';
export 'src/sembast/sembast_store.dart';

/// Creates a new in-memory [SembastVaultStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastVaultStore> newSembastMemoryVaultStore(
    {StoreCodec? codec,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastMemoryAdapter.build('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          sembastCodec: sembastCodec)
      .then((adapter) => SembastVaultStore(adapter, codec: codec));
}

/// Creates a new in-memory [SembastCacheStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastCacheStore> newSembastMemoryCacheStore(
    {StoreCodec? codec,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastMemoryAdapter.build('sembast',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          sembastCodec: sembastCodec)
      .then((adapter) => SembastCacheStore(adapter, codec: codec));
}

/// Creates a new [SembastVaultStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastVaultStore> newSembastLocalVaultStore(
    {String? path,
    StoreCodec? codec,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastLocalAdapter.build(path ?? 'vault.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          sembastCodec: sembastCodec)
      .then((adapter) => SembastVaultStore(adapter, codec: codec));
}

/// Creates a new [SembastCacheStore] on a file
///
/// * [path]: The location of this store, if not provided defaults to "stash_sembast.db"
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastCacheStore> newSembastLocalCacheStore(
    {String? path,
    StoreCodec? codec,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastLocalAdapter.build(path ?? 'cache.db',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          sembastCodec: sembastCodec)
      .then((adapter) => SembastCacheStore(adapter, codec: codec));
}
