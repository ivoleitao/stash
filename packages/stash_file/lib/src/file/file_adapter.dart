import 'dart:async';

import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:stream_transform/stream_transform.dart';

/// The [FileAdapter] provides a bridge between the store and the
/// File backend
class FileAdapter {
  /// The base location of the file storage
  final FileSystem fs;

  /// The base location of the file storage
  final String path;

  /// Map of partitions
  final Map<String, Directory> _partitions = {};

  /// [FileAdapter] constructor
  ///
  /// * [fs]: The [FileSystem]
  /// * [path]: The base location of the file storage
  FileAdapter._(this.fs, this.path);

  /// Builds [FileAdapter].
  ///
  /// * [fs]: The [FileSystem]
  /// * [path]: The base location of the file storage
  static Future<FileAdapter> build(FileSystem fs, String path) {
    return Future.value(FileAdapter._(fs, path));
  }

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      return fs
          .directory(p.join(path, name))
          .create(recursive: true)
          .then((directory) {
        _partitions[name] = directory;
      });
    }

    return Future.value();
  }

  /// Returns the partition [Directory]
  ///
  /// * [name]: The partition name
  ///
  /// Returns the partition [Directory]
  Directory? directory(String name) {
    return _partitions[name];
  }

  /// File] from a path
  ///
  /// * [path]: The path
  ///
  /// Returns a [File] from a path
  File file(String path) {
    return fs.file(path);
  }

  /// Returns a partition [File] identified by key
  ///
  /// * [name]: The name of the partition
  /// * [key]: The key
  ///
  /// Returns the [File] that stores the partition key
  File partitionFile(String name, String key) {
    return fs.file(p.join(path, name, key));
  }

  /// Returns the full list of files in a partition
  ///
  /// * [name]: The name of the partition
  /// * [convert]: Converts the file to the requested value
  /// * [predicate]: Predicate that filters the returned files
  ///
  /// Returns a list of files filtered and converted according with the
  /// provided parameters
  Future<List<T>> partitionFiles<T>(
      String name, FutureOr<T> Function(File) convert,
      {bool Function(FileSystemEntity fse)? predicate}) {
    final filter = predicate ?? ((fse) => true);
    final partitionDirectory = directory(name);

    if (partitionDirectory != null) {
      return partitionDirectory
          .list()
          .asyncWhere((fse) => fse.stat().then((FileStat stat) =>
              stat.type == FileSystemEntityType.file && filter(fse)))
          .cast<File>()
          .asyncMap(convert)
          .toList();
    }

    return Future.value(<T>[]);
  }

  /// Returns the partition [File] under the provided directory
  ///
  /// * [directory]: The partition [Directory]
  /// * [key]: The key
  ///
  /// Returns the partition [File] that under provided directory
  File directoryFile(Directory directory, String key) {
    return fs.file(p.join(directory.path, key));
  }

  /// Deletes a partition
  ///
  /// [name]: The partition name
  Future<void> _deletePartition(String name) {
    if (_partitions.containsKey(name)) {
      final partitionDirectory = _partitions[name]!;

      return partitionDirectory
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
