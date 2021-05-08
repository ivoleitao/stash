import 'dart:io';

import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/objectbox.g.dart';

import 'cache_entity.dart';

/// Objectbox based implemention of a [CacheStore]
class ObjectboxStore extends CacheStore {
  /// The base location of the Objectbox storage
  final String _path;

  /// The cache codec to use
  final CacheCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// List of stored per cache name
  final Map<String, Store> _cacheStoreMap = {};

  /// Builds a [ObjectboxStore].
  ///
  /// * [_path]: The base location of the Objectbox storage
  /// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  ObjectboxStore(this._path,
      {CacheCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _codec = codec ?? const MsgpackCodec(),
        _fromEncodable = fromEncodable;

  /// Returns the cache [Directory]
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the cache [Directory]
  Directory _cacheDirectory(String name) {
    return Directory(p.join(_path, name));
  }

  /// Returns the cache [Store] or opens a new store it under the base path
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [Store] of the cache
  Future<Store> _cacheStore(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      return Future.value(_cacheStoreMap[name]);
    }

    return _cacheDirectory(name).create().then((dir) {
      return _cacheStoreMap[name] =
          Store(getObjectBoxModel(), directory: dir.path);
    });
  }

  /// Returns the [Box] where a cache is stored
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [Box] where the cache is stored
  Future<Box<CacheEntity>> _objectbox(String name) {
    return _cacheStore(name).then((store) => store.box<CacheEntity>());
  }

  CacheEntity _toCacheEntity(CacheEntry entry) {
    final writer = _codec.encoder();
    writer.write(entry.value);

    return CacheEntity(
        id: entry.key.hashCode,
        key: entry.key,
        value: writer.takeBytes(),
        expiryTime: entry.expiryTime.toIso8601String(),
        creationTime: entry.creationTime.toIso8601String(),
        accessTime: entry.accessTime.toIso8601String(),
        updateTime: entry.updateTime.toIso8601String(),
        hitCount: entry.hitCount);
  }

  CacheEntry? _toCacheEntry(CacheEntity? entity) {
    if (entity != null) {
      final reader =
          _codec.decoder(entity.value, fromEncodable: _fromEncodable);
      final value = reader.read();

      return CacheEntry(entity.key, value, DateTime.parse(entity.expiryTime),
          DateTime.parse(entity.creationTime),
          accessTime: entity.accessTime != null
              ? DateTime.parse(entity.accessTime!)
              : null,
          updateTime: entity.updateTime != null
              ? DateTime.parse(entity.updateTime!)
              : null,
          hitCount: entity.hitCount);
    }

    return null;
  }

  @override
  Future<int> size(String name) => _objectbox(name).then((box) => box.count());

  @override
  Future<Iterable<String>> keys(String name) => _objectbox(name)
      .then((box) => box.getAll().map((entity) => entity.key).toList());

  @override
  Future<Iterable<CacheStat>> stats(String name) =>
      _objectbox(name).then((box) =>
          box.getAll().map((entity) => _toCacheEntry(entity)!.stat).toList());

  @override
  Future<Iterable<CacheEntry>> values(String name) => _objectbox(name).then(
      (box) => box.getAll().map((entity) => _toCacheEntry(entity)!).toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      _objectbox(name).then((box) => box.contains(key.hashCode));

  @override
  Future<CacheStat?> getStat(String name, String key) {
    return _objectbox(name)
        .then((box) => _toCacheEntry(box.get(key.hashCode))?.stat);
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) =>
      _objectbox(name).then((box) => box
          .getMany(keys.map((key) => key.hashCode).toList())
          .map((entity) => _toCacheEntry(entity)!)
          .toList());

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _objectbox(name).then((box) {
      final entity = box.get(key.hashCode);
      if (entity != null) {
        entity.expiryTime = stat.expiryTime.toIso8601String();
        entity.accessTime = stat.accessTime.toIso8601String();
        entity.updateTime = stat.updateTime.toIso8601String();
        entity.hitCount = stat.hitCount;

        box.put(entity, mode: PutMode.update);
      }
    });
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _objectbox(name).then((box) => _toCacheEntry(box.get(key.hashCode)));
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    return _objectbox(name)
        .then((box) => box.put(_toCacheEntity(entry), mode: PutMode.put));
  }

  @override
  Future<void> remove(String name, String key) {
    return _objectbox(name).then((box) => box.remove(key.hashCode));
  }

  @override
  Future<void> clear(String name) {
    return _objectbox(name).then((box) => box.removeAll());
  }

  @override
  Future<void> delete(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      _cacheStoreMap[name]?.close();
      return _cacheDirectory(name)
          .delete(recursive: true)
          .then((_) => _cacheStoreMap.remove(name));
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheStoreMap.keys.map((name) {
      _cacheStoreMap[name]?.close();
      return _cacheDirectory(name)
          .delete(recursive: true)
          .then((_) => _cacheStoreMap.remove(name));
    }));
  }
}
