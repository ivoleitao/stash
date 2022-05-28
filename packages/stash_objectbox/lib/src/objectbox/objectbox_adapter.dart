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

  /// Creates a store
  ///
  /// * [name]: The store name
  Future<void> create(String name) {
    if (!_stores.containsKey(name)) {
      return _directory(name).create().then((dir) {
        final store = Store(getObjectBoxModel(),
            directory: dir.path,
            maxDBSizeInKB: maxDBSizeInKB,
            fileMode: fileMode,
            maxReaders: maxReaders,
            queriesCaseSensitiveDefault: queriesCaseSensitiveDefault ?? true);

        _stores[name] = store;

        return Future.value();
      });
    }

    return Future.value();
  }

  /// Returns the [Store]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the [Store] of the store
  Store? _store(String name) {
    return _stores[name];
  }

  /// Returns the [Box]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the [Box]
  Box<O>? box<O>(String name) {
    return _store(name)?.box<O>();
  }

  /// Deletes a named store
  ///
  /// * [name]: The store name
  Future<void> _deleteStore(String name) {
    final store = _stores[name];

    if (store != null) {
      store.close();
      return _directory(name)
          .delete(recursive: true)
          .then((_) => _stores.remove(name));
    }

    return Future.value();
  }

  /// Deletes a named store
  ///
  /// * [name]: The store name
  Future<void> delete(String name) {
    return _deleteStore(name);
  }

  /// Deletes all the stores
  Future<void> deleteAll() {
    return Future.wait(_stores.keys.map((name) {
      return _deleteStore(name);
    }));
  }
}
