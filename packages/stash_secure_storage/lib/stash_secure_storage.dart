/// Provides a Secure Storage implementation of the Stash API for Dart
library stash_secure_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'src/secure_storage_adapter.dart';
import 'src/secure_storage_store.dart';

export 'src/secure_storage_adapter.dart';
export 'src/secure_storage_store.dart';

/// Creates a [SecureStorageVaultStore]
///
/// * [iOptions]: optional iOS options
/// * [aOptions]: optional Android options
/// * [lOptions]: optional Linux options
/// * [webOptions]: optional web options
/// * [mOptions]: optional MacOs options
/// * [wOptions]: optional Windows options
Future<SecureStorageVaultStore> newSecureStorageVaultStore(
    {IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions}) {
  return SecureStorageAdapter.build()
      .then((adapter) => SecureStorageVaultStore(adapter));
}

/// Creates a [SecureStorageCacheStore]
///
/// * [iOptions]: optional iOS options
/// * [aOptions]: optional Android options
/// * [lOptions]: optional Linux options
/// * [webOptions]: optional web options
/// * [mOptions]: optional MacOs options
/// * [wOptions]: optional Windows options
Future<SecureStorageCacheStore> newSecureStorageCacheStore(
    {IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions}) {
  return SecureStorageAdapter.build()
      .then((adapter) => SecureStorageCacheStore(adapter));
}
