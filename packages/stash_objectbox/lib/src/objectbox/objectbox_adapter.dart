import 'dart:io';

import 'package:path/path.dart' as p;

import '../../objectbox.g.dart';

/// The [ObjectboxAdapter] provides a bridge between the store and the
/// Hive backend
class ObjectboxAdapter {
  /// The base location of the Objectbox storage
  final String path;
  final int? maxDBSizeInKB;
  final int? fileMode;
  final int? maxReaders;
  final bool? queriesCaseSensitiveDefault;

  /// List of stores per cache name
  final Map<String, Store> _cacheStore = {};

  /// Builds a [ObjectboxAdapter].
  ///
  /// * [path]: The base location of the Objectbox storage
  /// * [maxDBSizeInKB]: The max DB size
  /// * [fileMode]: The file mode
  /// * [maxReaders]: The number of maximum readers
  /// * [queriesCaseSensitiveDefault]: If the queries are case sensitive
  ObjectboxAdapter(this.path,
      {this.maxDBSizeInKB,
      this.fileMode,
      this.maxReaders,
      this.queriesCaseSensitiveDefault});

  /// Returns the cache [Directory]
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the cache [Directory]
  Directory _cacheDirectory(String name) {
    return Directory(p.join(path, name));
  }

  /// Returns the cache [Store] or opens a new store it under the base path
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [Store] of the cache
  Future<Store> _store(String name) {
    if (_cacheStore.containsKey(name)) {
      return Future.value(_cacheStore[name]);
    }

    return _cacheDirectory(name).create().then((dir) {
      return _cacheStore[name] = Store(getObjectBoxModel(),
          directory: dir.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault ?? true);
    });
  }

  /// Returns the [Box] where a cache is stored
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [Box] where the cache is stored
  Future<Box<O>> box<O>(String name) {
    return _store(name).then((store) => store.box<O>());
  }

  /// Deletes a named cache from a store or the store itself if a named cache is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name) {
    if (_cacheStore.containsKey(name)) {
      _cacheStore[name]?.close();
      return _cacheDirectory(name)
          .delete(recursive: true)
          .then((_) => _cacheStore.remove(name));
    }

    return Future.value();
  }

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named caches in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_cacheStore.keys.map((name) {
      _cacheStore[name]?.close();
      return _cacheDirectory(name)
          .delete(recursive: true)
          .then((_) => _cacheStore.remove(name));
    }));
  }
}
