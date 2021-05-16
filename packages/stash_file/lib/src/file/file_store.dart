import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:stash/stash.dart';
import 'package:stream_transform/stream_transform.dart';

/// File based implemention of a [CacheStore]
class FileStore extends CacheStore {
  /// The size in bytes of the cache entry header
  static const int _header_size = uint64_size * 5;

  /// The base location of the file storage
  final FileSystem _fs;

  /// The base location of the file storage
  final String _path;

  /// The cache codec to use
  final CacheCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// List of cache directories per cache name
  final Map<String, Directory> _cacheDirectoryMap = {};

  /// Builds a [FileStore].
  /// * [_fs]: The [FileSystem]
  /// * [_path]: The base location of the file storage
  /// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  FileStore(this._fs, this._path,
      {CacheCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _codec = codec ?? const MsgpackCodec(),
        _fromEncodable = fromEncodable;

  /// Returns the [Directory] where a cache is stored or creates it under the base path
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [Directory] where the cache is stored
  Future<Directory> _cacheDirectory(String name) {
    if (_cacheDirectoryMap.containsKey(name)) {
      return Future.value(_cacheDirectoryMap[name]);
    } else {
      return _fs
          .directory(p.join(_path, name))
          .create(recursive: true)
          .then((cacheDirectory) {
        _cacheDirectoryMap[name] = cacheDirectory;

        return cacheDirectory;
      });
    }
  }

  /// Returns the cache [File]
  ///
  /// * [name]: The name of the cache
  /// * [key]: The named cache key
  ///
  /// Returns the [File] that stores the named cache key
  File _cacheFile(String name, String key) {
    return _fs.file(p.join(_path, name, key));
  }

  /// Returns the [File] that stores a cache key under the provided cache directory
  ///
  /// * [cacheDirectory]: The cache [Directory]
  /// * [key]: The cache key
  ///
  /// Returns the [File] that stores the cache key under the provided cache directory
  File _cacheDirectoryFile(Directory cacheDirectory, String key) {
    return _fs.file(p.join(cacheDirectory.path, key));
  }

  /// Returns the full list of cache files under a named directory
  ///
  /// * [name]: The name of the cache
  /// * [convert]: Converts the cache file to the requested value
  /// * [predicate]: Predicate that filters the returned cache files
  ///
  /// Returns a list of cache files filtered and converted according with the provided parameters
  Future<List<E>> _cacheFiles<E>(
      String name, FutureOr<E> Function(File) convert,
      {bool Function(FileSystemEntity fse)? predicate}) {
    final filter = predicate ?? ((fse) => true);
    return _cacheDirectory(name).then((cacheDirectory) => cacheDirectory
        .list()
        .asyncWhere((fse) => fse.stat().then((FileStat fstat) =>
            fstat.type == FileSystemEntityType.file && filter(fse)))
        .cast<File>()
        .asyncMap(convert)
        .toList());
  }

  /// Returns a list of the named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the list of keys of the provided cache
  Future<Iterable<String>> _getKeys(String name) =>
      _cacheFiles(name, (fse) => p.basename(fse.path));

  @override
  Future<int> size(String name) => _getKeys(name).then((it) => it.length);

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  @override
  Future<Iterable<CacheStat>> stats(String name) => _cacheFiles(
      name, (FileSystemEntity fse) => _readFileStat(_fs.file(fse.path)));

  @override
  Future<Iterable<CacheEntry>> values(String name) => _cacheFiles(
      name, (FileSystemEntity fse) => _readFileEntry(_fs.file(fse.path)));

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) =>
      _cacheFiles(name, (FileSystemEntity fse) => _getStat(_fs.file(fse.path)),
          predicate: (fse) => keys.contains(p.basename(fse.path)));

  @override
  Future<void> clear(String name) {
    return _cacheFiles(name, (FileSystemEntity fse) => fse.delete());
  }

  @override
  Future<bool> containsKey(String name, String key) {
    return _cacheFile(name, key).exists();
  }

  /// Creates a [CacheStat] from the provided byte list
  ///
  /// * [key]: The cache key
  /// * [bytes]: A [Uint8List] with the cache value
  ///
  /// Returns a [CacheStat]
  CacheStat _readStat(String key, Uint8List bytes) {
    var reader = _codec.decoder(bytes);

    var expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var creationTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var hitCount = reader.readUInt64();

    return CacheStat(key, expiryTime, creationTime,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }

  Future<CacheStat> _readFileStat(File file) =>
      file.open(mode: FileMode.read).then((f) {
        return f
            .read(_header_size)
            .then(((bytes) => _readStat(p.basename(file.path), bytes)))
            .whenComplete(() => f.close());
      });

  /// Creates a [CacheStat] from the provided [File]
  ///
  /// * [file]: The cache [File]
  /// * [checkFile]: If the existence of the file should be checked, defaults to false
  ///
  /// Returns a [CacheStat]
  Future<CacheStat?> _getStat(File file, {bool checkFile = false}) {
    final statGet =
        (bool readFile) => readFile ? _readFileStat(file) : Future.value(null);

    return checkFile ? file.exists().then(statGet) : statGet(true);
  }

  @override
  Future<CacheStat?> getStat(String name, String key) {
    return _getStat(_cacheFile(name, key), checkFile: true);
  }

  /// Updates only the statistics of a cache not the full cache
  ///
  /// * [stat]: The [CacheStat] to write
  /// * [writer]: An optional instance of the [BytesWriter] in case it was already instanciated.
  ///
  /// Returns the provided [BytesWriter] or a new one after writing [CacheStat] into it
  BytesWriter _writeStat(CacheStat stat, {BytesWriter? writer}) {
    writer = writer ?? _codec.encoder();

    writer.writeUint64(stat.expiryTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.creationTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.accessTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.updateTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.hitCount);

    return writer;
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _cacheFile(name, key).open(mode: FileMode.append).then((file) {
      file
          .setPosition(0)
          .then((file) => file.writeFrom(_writeStat(stat).takeBytes()))
          .whenComplete(() => file.close());
    });
  }

  /// Reads a [CacheEntry] from a [Uint8List]
  ///
  /// * [key]: The cache key
  /// * [bytes]: The list of bytes from where the [CacheEntry] should be read
  ///
  /// Returns a [CacheEntry]
  CacheEntry _readEntry(String key, Uint8List bytes) {
    var reader = _codec.decoder(bytes, fromEncodable: _fromEncodable);

    var expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var creationTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    var hitCount = reader.readUInt64();
    var value = reader.read();

    return CacheEntry(key, value, expiryTime, creationTime,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }

  /// Reads a [CacheEntry] from the provided [File]
  ///
  /// * [file]: The cache [File]
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry> _readFileEntry(File file) => file
      .readAsBytes()
      .then((bytes) => _readEntry(p.basename(file.path), bytes));

  /// Gets a [CacheEntry] from the provided [File]
  ///
  /// * [file]: The cache [File]
  /// * [checkFile]: If the existence of the [File] should be checked
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntry(File file, {bool checkFile = false}) {
    final entryGet =
        (bool readFile) => readFile ? _readFileEntry(file) : Future.value(null);

    return checkFile ? file.exists().then(entryGet) : entryGet(true);
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _getEntry(_cacheFile(name, key), checkFile: true);
  }

  /// Writes a value to a optionally provided [BytesWriter] or creates a new one
  ///
  /// * [value]: The value to write to the cache
  /// * [writer]: The optionally provided [BytesWriter]
  ///
  /// Returns the provided [BytesWriter] or a new one after writing [value] into it
  BytesWriter _writeValue(dynamic value, {BytesWriter? writer}) {
    writer = writer ?? _codec.encoder();

    writer.write(value);

    return writer;
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    var writer = _codec.encoder();

    _writeStat(entry, writer: writer);
    _writeValue(entry.value, writer: writer);

    return _cacheDirectory(name).then((cacheDirectory) {
      return _cacheDirectoryFile(cacheDirectory, key)
          .writeAsBytes(writer.takeBytes());
    });
  }

  @override
  Future<void> remove(String name, String key) {
    if (_cacheDirectoryMap.containsKey(name)) {
      return _cacheFile(name, key).delete();
    }

    return Future.value();
  }

  @override
  Future<void> delete(String name) {
    if (_cacheDirectoryMap.containsKey(name)) {
      final cacheDirectory = _cacheDirectoryMap[name]!;

      return cacheDirectory
          .delete(recursive: true)
          .then((_) => _cacheDirectoryMap.remove(name));
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheDirectoryMap.keys.map((name) {
      final cacheDirectory = _cacheDirectoryMap[name];
      if (cacheDirectory != null) {
        return cacheDirectory
            .delete(recursive: true)
            .then((_) => _cacheDirectoryMap.remove(name));
      }

      return Future.value();
    }));
  }
}
