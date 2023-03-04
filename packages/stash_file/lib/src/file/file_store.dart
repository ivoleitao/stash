import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:stash/stash_api.dart';

import 'file_adapter.dart';

/// File based implemention of a [Store]
abstract class FileStore<I extends Info, E extends Entry<I>>
    extends PersistenceStore<I, E> {
  /// The adapter
  final FileAdapter _adapter;

  /// If locks are obtained before performing read/write operations
  final bool lock;

  /// Builds a [FileStore].
  ///
  /// * [_adapter]: The file store adapter
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  FileStore(this._adapter, this.lock, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  /// Returns a list of keys in the partition
  ///
  /// * [name]: The name of the partition
  ///
  /// Returns the list of keys in the partition
  Future<Iterable<String>> _getKeys(String name) =>
      _adapter.partitionFiles(name, (fse) => p.basename(fse.path));

  @override
  Future<int> size(String name) => _getKeys(name).then((it) => it.length);

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  @override
  Future<Iterable<I>> infos(String name) => _adapter.partitionFiles(
      name, (FileSystemEntity fse) => _readFileInfo(_adapter.file(fse.path)));

  @override
  Future<Iterable<E>> values(String name) => _adapter.partitionFiles(
      name, (FileSystemEntity fse) => _readFileEntry(_adapter.file(fse.path)));

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) =>
      _adapter.partitionFiles(
          name, (FileSystemEntity fse) => _getInfo(_adapter.file(fse.path)),
          predicate: (fse) => keys.contains(p.basename(fse.path)));

  @override
  Future<void> clear(String name) {
    return _adapter.partitionFiles(
        name, (FileSystemEntity fse) => fse.delete());
  }

  @override
  Future<bool> containsKey(String name, String key) {
    return _adapter.partitionFile(name, key).exists();
  }

  /// The size of the [Info] header
  @protected
  int get _headerSize;

  /// Creates a [Info] from the provided byte list
  ///
  /// * [key]: The partition key
  /// * [bytes]: A [Uint8List] with the partition value
  ///
  /// Returns a [Info]
  @protected
  I _readInfo(String key, Uint8List bytes);

  /// Reads a [Info] from a [File]
  ///
  /// * [file]: The [File] to read the data from
  ///
  /// Return [file] [Info]
  Future<I> _readFileInfo(File file) =>
      file.open(mode: FileMode.read).then((raf) {
        final pre = lock
            ? (RandomAccessFile f) => f.lock(FileLock.blockingShared)
            : (RandomAccessFile f) => Future.value(f);
        final pos = lock
            ? () => raf.unlock().then((f) => f.close())
            : () => raf.close();

        return pre(raf)
            .then((f) => f.read(_headerSize))
            .then(((bytes) => _readInfo(p.basename(file.path), bytes)))
            .whenComplete(pos);
      });

  /// Creates a [Info] from the provided [File]
  ///
  /// * [file]: The partition [File]
  /// * [checkFile]: If the existence of the file should be checked, defaults to false
  ///
  /// Returns a [Info]
  Future<I?> _getInfo(File file, {bool checkFile = false}) {
    infoGet(bool readFile) =>
        readFile ? _readFileInfo(file) : Future.value(null);

    return checkFile ? file.exists().then(infoGet) : infoGet(true);
  }

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfo(_adapter.partitionFile(name, key), checkFile: true);
  }

  /// Updates only the information of a entry not the full entry
  ///
  /// * [info]: The [Info] to write
  /// * [writer]: An optional instance of the [BytesWriter] in case it was already instanciated.
  ///
  /// Returns the provided [BytesWriter] or a new one after writing [Info] into it
  @protected
  BytesWriter _writeInfo(I info, {BytesWriter? writer});

  @override
  Future<void> setInfo(String name, String key, I info) {
    return _adapter
        .partitionFile(name, key)
        .open(mode: FileMode.append)
        .then((raf) {
      final pre = lock
          ? (RandomAccessFile f) => f.lock(FileLock.blockingExclusive)
          : (RandomAccessFile f) => Future.value(f);
      final pos =
          lock ? () => raf.unlock().then((f) => f.close()) : () => raf.close();

      return pre(raf)
          .then((f) => f.setPosition(0))
          .then((f) => f.writeFrom(_writeInfo(info).takeBytes()))
          .whenComplete(pos)
          .then((_) => null);
    });
  }

  /// Obtains the partition `fromEncodable` function
  ///
  /// * [name]: The partition name
  dynamic Function(Map<String, dynamic>)? fileFromEncodable(File file) {
    return decoder(p.basename(p.dirname(file.path)));
  }

  /// Reads a [Entry] from a [Uint8List]
  ///
  /// * [key]: The partition key
  /// * [bytes]: The list of bytes from where the [Entry] should be read
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  ///
  /// Returns a [Entry]
  E _readEntry(String key, Uint8List bytes,
      dynamic Function(Map<String, dynamic>)? fromEncodable);

  /// Reads a [Entry] from the provided [File]
  ///
  /// * [file]: The partition [File]
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
          return raf.readInto(buffer, 0, length).then((_) => _readEntry(
              p.basename(file.path), buffer, fileFromEncodable(file)));
        }).whenComplete(() => raf.unlock().then((value) => raf.close()));
      });
    } else {
      return file.readAsBytes().then((bytes) =>
          _readEntry(p.basename(file.path), bytes, fileFromEncodable(file)));
    }
  }

  /// Gets a [Entry] from the provided [File]
  ///
  /// * [file]: The partition [File]
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
    return _getEntry(_adapter.partitionFile(name, key), checkFile: true);
  }

  /// Writes a value to a optionally provided [BytesWriter] or creates a new one
  ///
  /// * [value]: The value to write to the partition
  /// * [writer]: The optionally provided [BytesWriter]
  ///
  /// Returns the provided [BytesWriter] or a new one after writing [value] into it
  BytesWriter _writeValue(dynamic value, {BytesWriter? writer}) {
    writer = writer ?? codec.encoder();

    writer.write(value);

    return writer;
  }

  Future<void> _putFileEntry(File file, E entry) {
    var writer = codec.encoder();

    _writeInfo(entry.info, writer: writer);
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
    final directory = _adapter.directory(name);

    if (directory != null) {
      return _putFileEntry(_adapter.directoryFile(directory, key), entry);
    }

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final directory = _adapter.directory(name);

    if (directory != null) {
      return _adapter.partitionFile(name, key).delete();
    }

    return Future.value();
  }

  @override
  Future<void> delete(String name) {
    return _adapter.delete(name);
  }

  @override
  Future<void> deleteAll() {
    return _adapter.deleteAll();
  }
}

class FileVaultStore extends FileStore<VaultInfo, VaultEntry>
    implements VaultStore {
  /// The size in bytes of the store entry header
  static const int _vaultHeaderSize = uint64Size * 3;

  @override
  int get _headerSize => _vaultHeaderSize;

  /// Builds a [FileVaultStore].
  ///
  /// * [adapter]: The file store adapter
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  FileVaultStore(super.adapter, super.lock, {super.codec});

  @override
  VaultInfo _readInfo(String key, Uint8List bytes) {
    final reader = codec.decoder(bytes);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());

    return VaultInfo(key, creationTime,
        accessTime: accessTime, updateTime: updateTime);
  }

  @override
  BytesWriter _writeInfo(VaultInfo info, {BytesWriter? writer}) {
    writer = writer ?? codec.encoder();

    writer.writeUint64(info.creationTime.microsecondsSinceEpoch);
    writer.writeUint64(info.accessTime.microsecondsSinceEpoch);
    writer.writeUint64(info.updateTime.microsecondsSinceEpoch);

    return writer;
  }

  @override
  VaultEntry _readEntry(String key, Uint8List bytes,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    final reader = codec.decoder(bytes, fromEncodable: fromEncodable);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final value = reader.read();

    return VaultEntry.loaded(key, creationTime, value,
        accessTime: accessTime, updateTime: updateTime);
  }
}

class FileCacheStore extends FileStore<CacheInfo, CacheEntry>
    implements CacheStore {
  /// The size in bytes of the cache entry header
  static const int _cacheHeaderSize = uint64Size * 5;

  @override
  int get _headerSize => _cacheHeaderSize;

  /// Builds a [FileCacheStore].
  /// * [adapter]: The adapter
  /// * [lock]: If locks are obtained before doing read/write operations
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  FileCacheStore(super.adapter, super.lock, {super.codec});

  @override
  CacheInfo _readInfo(String key, Uint8List bytes) {
    final reader = codec.decoder(bytes);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final hitCount = reader.readUInt64();

    return CacheInfo(key, creationTime, expiryTime,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }

  @override
  BytesWriter _writeInfo(CacheInfo info, {BytesWriter? writer}) {
    writer = writer ?? codec.encoder();

    writer.writeUint64(info.creationTime.microsecondsSinceEpoch);
    writer.writeUint64(info.expiryTime.microsecondsSinceEpoch);
    writer.writeUint64(info.accessTime.microsecondsSinceEpoch);
    writer.writeUint64(info.updateTime.microsecondsSinceEpoch);
    writer.writeUint64(info.hitCount);

    return writer;
  }

  @override
  CacheEntry _readEntry(String key, Uint8List bytes,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    final reader = codec.decoder(bytes, fromEncodable: fromEncodable);

    final creationTime =
        DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final expiryTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final accessTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final updateTime = DateTime.fromMicrosecondsSinceEpoch(reader.readUInt64());
    final hitCount = reader.readUInt64();
    final value = reader.read();

    return CacheEntry.loaded(key, creationTime, expiryTime, value,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }
}
