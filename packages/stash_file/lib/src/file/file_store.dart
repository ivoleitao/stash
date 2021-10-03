import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:stash/stash_api.dart';
import 'package:stash/stash_msgpack.dart';
import 'package:stream_transform/stream_transform.dart';

/// File based implemention of a [CacheStore]
abstract class FileStore<S extends Stat, E extends Entry<S>>
    implements Store<S, E> {
  /// The base location of the file storage
  final FileSystem _fs;

  /// The base location of the file storage
  final String _path;

  /// If locks are obtained before performing read/write operations
  final bool lock;

  /// The cache codec to use
  final StoreCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// List of cache directories per cache name
  final Map<String, Directory> _cacheDirectoryMap = {};

  /// Builds a [FileStore].
  /// * [_fs]: The [FileSystem]
  /// * [_path]: The base location of the file storage
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  FileStore(this._fs, this._path, this.lock,
      {StoreCodec? codec,
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
  Future<List<T>> _cacheFiles<T>(
      String name, FutureOr<T> Function(File) convert,
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
  Future<Iterable<S>> stats(String name) => _cacheFiles(
      name, (FileSystemEntity fse) => _readFileStat(_fs.file(fse.path)));

  @override
  Future<Iterable<E>> values(String name) => _cacheFiles(
      name, (FileSystemEntity fse) => _readFileEntry(_fs.file(fse.path)));

  @override
  Future<Iterable<S?>> getStats(String name, Iterable<String> keys) =>
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

  /// The size of the [Stat] header
  @protected
  int get _headerSize;

  /// Creates a [Stat] from the provided byte list
  ///
  /// * [key]: The cache key
  /// * [bytes]: A [Uint8List] with the cache value
  ///
  /// Returns a [Stat]
  @protected
  S _readStat(String key, Uint8List bytes);

  /// Reads a [Stat] from a [File]
  ///
  /// * [file]: The [File] to read the data from
  ///
  /// Return [file] [Stat]
  Future<S> _readFileStat(File file) =>
      file.open(mode: FileMode.read).then((raf) {
        final pre = lock
            ? (RandomAccessFile f) => f.lock(FileLock.blockingShared)
            : (RandomAccessFile f) => Future.value(f);
        final pos = lock
            ? () => raf.unlock().then((f) => f.close())
            : () => raf.close();

        return pre(raf)
            .then((f) => f.read(_headerSize))
            .then(((bytes) => _readStat(p.basename(file.path), bytes)))
            .whenComplete(pos);
      });

  /// Creates a [Stat] from the provided [File]
  ///
  /// * [file]: The cache [File]
  /// * [checkFile]: If the existence of the file should be checked, defaults to false
  ///
  /// Returns a [Stat]
  Future<S?> _getStat(File file, {bool checkFile = false}) {
    statGet(bool readFile) =>
        readFile ? _readFileStat(file) : Future.value(null);

    return checkFile ? file.exists().then(statGet) : statGet(true);
  }

  @override
  Future<S?> getStat(String name, String key) {
    return _getStat(_cacheFile(name, key), checkFile: true);
  }

  /// Updates only the statistics of a cache not the full cache
  ///
  /// * [stat]: The [Stat] to write
  /// * [writer]: An optional instance of the [BytesWriter] in case it was already instanciated.
  ///
  /// Returns the provided [BytesWriter] or a new one after writing [Stat] into it
  @protected
  BytesWriter _writeStat(S stat, {BytesWriter? writer});

  @override
  Future<void> setStat(String name, String key, S stat) {
    return _cacheFile(name, key).open(mode: FileMode.append).then((raf) {
      final pre = lock
          ? (RandomAccessFile f) => f.lock(FileLock.blockingExclusive)
          : (RandomAccessFile f) => Future.value(f);
      final pos =
          lock ? () => raf.unlock().then((f) => f.close()) : () => raf.close();

      return pre(raf)
          .then((f) => f.setPosition(0))
          .then((f) => f.writeFrom(_writeStat(stat).takeBytes()))
          .whenComplete(pos)
          .then((_) => null);
    });
  }

  /// Reads a [Entry] from a [Uint8List]
  ///
  /// * [key]: The cache key
  /// * [bytes]: The list of bytes from where the [Entry] should be read
  ///
  /// Returns a [Entry]
  E _readEntry(String key, Uint8List bytes);

  /// Reads a [Entry] from the provided [File]
  ///
  /// * [file]: The cache [File]
  ///
  /// Returns a [Entry]
  Future<E> _readFileEntry(File file) {
    if (lock) {
      return file.open(mode: FileMode.read).then((raf) {
        return raf
            .lock(FileLock.blockingShared)
            .then((f) => f.length())
            .then((length) {
          final buffer = Uint8List(length);
          return raf
              .readInto(buffer, 0, length)
              .then((_) => _readEntry(p.basename(file.path), buffer));
        }).whenComplete(() => raf.unlock().then((value) => raf.close()));
      });
    } else {
      return file
          .readAsBytes()
          .then((bytes) => _readEntry(p.basename(file.path), bytes));
    }
  }

  /// Gets a [Entry] from the provided [File]
  ///
  /// * [file]: The cache [File]
  /// * [checkFile]: If the existence of the [File] should be checked
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(File file, {bool checkFile = false}) {
    entryGet(bool readFile) =>
        readFile ? _readFileEntry(file) : Future.value(null);

    return checkFile ? file.exists().then(entryGet) : entryGet(true);
  }

  @override
  Future<E?> getEntry(String name, String key) {
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

  Future<void> _putFileEntry(File file, E entry) {
    var writer = _codec.encoder();

    _writeStat(entry.stat, writer: writer);
    _writeValue(entry.value, writer: writer);

    final buffer = writer.takeBytes();
    if (lock) {
      return file.open(mode: FileMode.writeOnly).then((raf) {
        return raf
            .lock(FileLock.blockingExclusive)
            .then((f) => f.writeFrom(buffer, 0, buffer.length))
            .whenComplete(() => raf.unlock().then((value) => raf.close()));
      }).then((_) => null);
    } else {
      return file.writeAsBytes(buffer).then((_) => null);
    }
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _cacheDirectory(name).then((cacheDirectory) {
      return _putFileEntry(_cacheDirectoryFile(cacheDirectory, key), entry);
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

class FileVaultStore extends FileStore<VaultStat, VaultEntry> {
  /// The size in bytes of the cache entry header
  static const int _cacheHeaderSize = uint64Size * 3;

  @override
  int get _headerSize => _cacheHeaderSize;

  /// Builds a [FileCacheStore].
  /// * [fs]: The [FileSystem]
  /// * [path]: The base location of the file storage
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  FileVaultStore(FileSystem fs, String path,
      {bool lock = true,
      StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(fs, path, lock);

  @override
  VaultStat _readStat(String key, Uint8List bytes) {
    final reader = _codec.decoder(bytes);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());

    return VaultStat(key, creationTime,
        accessTime: accessTime, updateTime: updateTime);
  }

  @override
  BytesWriter _writeStat(VaultStat stat, {BytesWriter? writer}) {
    writer = writer ?? _codec.encoder();

    writer.writeUint64(stat.creationTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.accessTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.updateTime.microsecondsSinceEpoch);

    return writer;
  }

  @override
  VaultEntry _readEntry(String key, Uint8List bytes) {
    final reader = _codec.decoder(bytes, fromEncodable: _fromEncodable);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final value = reader.read();

    return VaultEntry.newEntry(key, creationTime, value,
        accessTime: accessTime, updateTime: updateTime);
  }
}

class FileCacheStore extends FileStore<CacheStat, CacheEntry> {
  /// The size in bytes of the cache entry header
  static const int _cacheHeaderSize = uint64Size * 5;

  @override
  int get _headerSize => _cacheHeaderSize;

  /// Builds a [FileCacheStore].
  /// * [fs]: The [FileSystem]
  /// * [path]: The base location of the file storage
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  FileCacheStore(FileSystem fs, String path,
      {bool lock = true,
      StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(fs, path, lock, codec: codec, fromEncodable: fromEncodable);

  @override
  CacheStat _readStat(String key, Uint8List bytes) {
    final reader = _codec.decoder(bytes);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final hitCount = reader.readUInt64();

    return CacheStat(key, creationTime, expiryTime,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }

  @override
  BytesWriter _writeStat(CacheStat stat, {BytesWriter? writer}) {
    writer = writer ?? _codec.encoder();

    writer.writeUint64(stat.creationTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.expiryTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.accessTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.updateTime.microsecondsSinceEpoch);
    writer.writeUint64(stat.hitCount);

    return writer;
  }

  @override
  CacheEntry _readEntry(String key, Uint8List bytes) {
    final reader = _codec.decoder(bytes, fromEncodable: _fromEncodable);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final hitCount = reader.readUInt64();
    final value = reader.read();

    return CacheEntry.newEntry(key, creationTime, expiryTime, value,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }
}
