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

  /// List of partitions per name
  final Map<String, Store> _partitions = {};

  /// [ObjectboxAdapter] constructor
  ///
  /// * [path]: The base location of the Objectbox storage
  /// * [maxDBSizeInKB]: The max DB size
  /// * [fileMode]: The file mode
  /// * [maxReaders]: The number of maximum readers
  /// * [queriesCaseSensitiveDefault]: If the queries are case sensitive
  ObjectboxAdapter._(this.path,
      {this.maxDBSizeInKB,
      this.fileMode,
      this.maxReaders,
      this.queriesCaseSensitiveDefault});

  /// Builds [ObjectboxAdapter].
  ///
  /// * [path]: The base location of the Objectbox storage
  /// * [maxDBSizeInKB]: The max DB size
  /// * [fileMode]: The file mode
  /// * [maxReaders]: The number of maximum readers
  /// * [queriesCaseSensitiveDefault]: If the queries are case sensitive
  static Future<ObjectboxAdapter> build(String path,
      {int? maxDBSizeInKB,
      int? fileMode,
      int? maxReaders,
      bool? queriesCaseSensitiveDefault}) {
    return Future.value(ObjectboxAdapter._(path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault));
  }

  /// Returns the partition [Directory]
  ///
  /// * [name]: The name of the partition
  ///
  /// Returns the partition [Directory]
  Directory _directory(String name) {
    return Directory(p.join(path, name));
  }

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      return _directory(name).create().then((dir) {
        final store = Store(getObjectBoxModel(),
            directory: dir.path,
            maxDBSizeInKB: maxDBSizeInKB,
            fileMode: fileMode,
            maxReaders: maxReaders,
            queriesCaseSensitiveDefault: queriesCaseSensitiveDefault ?? true);

        _partitions[name] = store;

        return Future.value();
      });
    }

    return Future.value();
  }

  /// Returns the [Store]
  ///
  /// * [name]: The partition name
  ///
  /// Returns the partition [Store]
  Store? _partition(String name) {
    return _partitions[name];
  }

  /// Returns a partition [Box]
  ///
  /// * [name]: The partition name
  ///
  /// Returns the [Box]
  Box<O>? box<O>(String name) {
    return _partition(name)?.box<O>();
  }

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> _deletePartition(String name) {
    final store = _partitions[name];

    if (store != null) {
      store.close();
      return _directory(name)
          .delete(recursive: true)
          .then((_) => _partitions.remove(name));
    }

    return Future.value();
  }

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> delete(String name) {
    return _deletePartition(name);
  }

  /// Deletes all the partitions
  Future<void> deleteAll() {
    return Future.wait(_partitions.keys.map((name) {
      return _deletePartition(name);
    }));
  }
}
