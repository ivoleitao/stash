/// Provides a file implementation of the stash caching API for Dart
library stash_file;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_file/src/file/file_adapter.dart';
import 'package:stash_file/src/file/file_store.dart';

export 'src/file/file_store.dart';

/// Creates a new in-memory [FileVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<FileVaultStore> newFileMemoryVaultStore(
    {String? path, StoreCodec? codec}) {
  FileSystem fs = MemoryFileSystem();

  return FileAdapter.build(fs, path ?? fs.systemTempDirectory.path)
      .then((adapter) => FileVaultStore(adapter, false, codec: codec));
}

/// Creates a new in-memory [FileCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<FileCacheStore> newFileMemoryCacheStore(
    {String? path, StoreCodec? codec}) {
  FileSystem fs = MemoryFileSystem();

  return FileAdapter.build(fs, path ?? fs.systemTempDirectory.path)
      .then((adapter) => FileCacheStore(adapter, false, codec: codec));
}

/// Creates a local [FileVaultStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<FileVaultStore> newFileLocalVaultStore(
    {String? path, StoreCodec? codec}) {
  FileSystem fs = const LocalFileSystem();

  return FileAdapter.build(fs, path ?? fs.systemTempDirectory.path)
      .then((adapter) => FileVaultStore(adapter, true, codec: codec));
}

/// Creates a local [FileCacheStore]
///
/// * [path]: The base storage location for this store
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<FileCacheStore> newFileLocalCacheStore(
    {String? path, StoreCodec? codec}) {
  FileSystem fs = const LocalFileSystem();

  return FileAdapter.build(fs, path ?? fs.systemTempDirectory.path)
      .then((adapter) => FileCacheStore(adapter, true, codec: codec));
}
