/// Provides a Sembast Web implementation of the Stash caching API for Dart
library stash_sembast_web;

import 'package:sembast/sembast.dart';
import 'package:stash_sembast/stash_sembast.dart';
import 'package:stash_sembast_web/src/sembast/sembast_web_adapter.dart';

export 'src/sembast/sembast_web_adapter.dart';

/// Creates a new web [SembastVaultStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastVaultStore> newSembastWebVaultStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastWebAdapter.build('sembast_web',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastVaultStore(adapter, fromEncodable: fromEncodable));
}

/// Creates a new web [SembastCacheStore]
///
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [databaseVersion]: The expected version
/// * [onVersionChanged]:  If [databaseVersion] not null and if the existing version is different, onVersionChanged is called
/// * [databaseMode]: The database mode
/// * [sembastCodec]: The codec which can be used to load/save a record, allowing for user encryption
Future<SembastCacheStore> newSembastWebCacheStore(
    {dynamic Function(Map<String, dynamic>)? fromEncodable,
    int? databaseVersion,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? databaseMode,
    SembastCodec? sembastCodec}) {
  return SembastWebAdapter.build('sembast_web',
          version: databaseVersion,
          onVersionChanged: onVersionChanged,
          mode: databaseMode,
          codec: sembastCodec)
      .then((adapter) =>
          SembastCacheStore(adapter, fromEncodable: fromEncodable));
}
