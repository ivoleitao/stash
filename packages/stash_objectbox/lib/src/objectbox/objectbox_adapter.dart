import 'dart:async';
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

  /// List of stores per name
  final Map<String, Store> _stores = {};

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

  /// Returns the store [Directory]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the store [Directory]
  Directory _directory(String name) {
    return Directory(p.join(path, name));
  }

  /// Returns the [Store] or opens a new store it under the base path
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the [Store] of the store
  Future<Store> _store(String name) {
    if (_stores.containsKey(name)) {
      return Future.value(_stores[name]);
    }

    return _directory(name).create().then((dir) {
      final store = Store(getObjectBoxModel(),
          directory: dir.path,
          maxDBSizeInKB: maxDBSizeInKB,
          fileMode: fileMode,
          maxReaders: maxReaders,
          queriesCaseSensitiveDefault: queriesCaseSensitiveDefault ?? true);

      _stores[name] = store;

      return Future.value(store);
    });
  }

  /// Returns the [Box]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the [Box]
  Future<Box<O>> box<O>(String name) {
    return _store(name).then((store) => store.box<O>());
  }

  /// Deletes a named store or the store itself if is
  /// stored individually
  ///
  /// * [name]: The store name
  Future<void> _deleteStore(String name) {
    if (_stores.containsKey(name)) {
      _stores[name]?.close();
      return _directory(name)
          .delete(recursive: true)
          .then((_) => _stores.remove(name));
    }

    return Future.value();
  }

  /// Deletes a named store or the store itself if is
  /// stored individually
  ///
  /// * [name]: The store name
  Future<void> delete(String name) {
    return _deleteStore(name);
  }

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named stores in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_stores.keys.map((name) {
      return _deleteStore(name);
    }));
  }
}
