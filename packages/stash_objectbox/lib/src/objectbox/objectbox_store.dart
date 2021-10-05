import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';
import 'package:stash/stash_msgpack.dart';
import 'package:stash_objectbox/objectbox.g.dart' show PutMode;

import 'cache_entity.dart';
import 'objectbox_adapter.dart';
import 'objectbox_entity.dart';
import 'vault_entity.dart';

/// Objectbox based implemention of a [Store]
abstract class ObjectboxStore<O extends ObjectboxEntity, S extends Stat,
    E extends Entry<S>> implements Store<S, E> {
  /// The adapter
  final ObjectboxAdapter _adapter;

  /// The cache codec to use
  final StoreCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [ObjectboxStore].
  ///
  /// * [_adapter]: The objectbox store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  ObjectboxStore(this._adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _codec = codec ?? const MsgpackCodec(),
        _fromEncodable = fromEncodable;

  @protected
  O _toEntity(E entry);

  @protected
  E? _toEntry(O? entity);

  @override
  Future<int> size(String name) =>
      _adapter.box<O>(name).then((box) => box.count());

  @override
  Future<Iterable<String>> keys(String name) => _adapter
      .box<O>(name)
      .then((box) => box.getAll().map((entity) => entity.key).toList());

  @override
  Future<Iterable<S>> stats(String name) => _adapter.box<O>(name).then(
      (box) => box.getAll().map((entity) => _toEntry(entity)!.stat).toList());

  @override
  Future<Iterable<E>> values(String name) => _adapter
      .box<O>(name)
      .then((box) => box.getAll().map((entity) => _toEntry(entity)!).toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.box<O>(name).then((box) => box.contains(key.hashCode));

  @override
  Future<S?> getStat(String name, String key) {
    return _adapter
        .box<O>(name)
        .then((box) => _toEntry(box.get(key.hashCode))?.stat);
  }

  @override
  Future<Iterable<S?>> getStats(String name, Iterable<String> keys) =>
      _adapter.box<O>(name).then((box) => box
          .getMany(keys.map((key) => key.hashCode).toList())
          .map((entity) => _toEntry(entity)?.stat)
          .toList());

  @protected
  void _writeStat(O entity, S stat);

  @override
  Future<void> setStat(String name, String key, S stat) {
    return _adapter.box<O>(name).then((box) {
      final entity = box.get(key.hashCode);
      if (entity != null) {
        _writeStat(entity, stat);
        box.put(entity, mode: PutMode.update);
      }
    });
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _adapter.box<O>(name).then((box) => _toEntry(box.get(key.hashCode)));
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _adapter
        .box<O>(name)
        .then((box) => box.put(_toEntity(entry), mode: PutMode.put));
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.box<O>(name).then((box) => box.remove(key.hashCode));
  }

  @override
  Future<void> clear(String name) {
    return _adapter.box<O>(name).then((box) => box.removeAll());
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

class ObjectboxVaultStore
    extends ObjectboxStore<VaultEntity, VaultStat, VaultEntry> {
  ObjectboxVaultStore(ObjectboxAdapter adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, codec: codec, fromEncodable: fromEncodable);

  @override
  VaultEntity _toEntity(VaultEntry entry) {
    final writer = _codec.encoder();
    writer.write(entry.value);

    return VaultEntity(
        id: entry.key.hashCode,
        key: entry.key,
        value: writer.takeBytes(),
        creationTime: entry.creationTime.toIso8601String(),
        accessTime: entry.accessTime.toIso8601String(),
        updateTime: entry.updateTime.toIso8601String());
  }

  @override
  VaultEntry? _toEntry(VaultEntity? entity) {
    if (entity != null) {
      final reader =
          _codec.decoder(entity.value, fromEncodable: _fromEncodable);
      final value = reader.read();

      return VaultEntry.newEntry(
          entity.key, DateTime.parse(entity.creationTime), value,
          accessTime: entity.accessTime != null
              ? DateTime.parse(entity.accessTime!)
              : null,
          updateTime: entity.updateTime != null
              ? DateTime.parse(entity.updateTime!)
              : null);
    }

    return null;
  }

  @override
  void _writeStat(VaultEntity entity, VaultStat stat) {
    entity.accessTime = stat.accessTime.toIso8601String();
    entity.updateTime = stat.updateTime.toIso8601String();
  }
}

class ObjectboxCacheStore
    extends ObjectboxStore<CacheEntity, CacheStat, CacheEntry> {
  ObjectboxCacheStore(ObjectboxAdapter adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, codec: codec, fromEncodable: fromEncodable);

  @override
  CacheEntity _toEntity(CacheEntry entry) {
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

  @override
  CacheEntry? _toEntry(CacheEntity? entity) {
    if (entity != null) {
      final reader =
          _codec.decoder(entity.value, fromEncodable: _fromEncodable);
      final value = reader.read();

      return CacheEntry.newEntry(
          entity.key,
          DateTime.parse(entity.creationTime),
          DateTime.parse(entity.expiryTime),
          value,
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
  void _writeStat(CacheEntity entity, CacheStat stat) {
    entity.expiryTime = stat.expiryTime.toIso8601String();
    entity.accessTime = stat.accessTime.toIso8601String();
    entity.updateTime = stat.updateTime.toIso8601String();
    entity.hitCount = stat.hitCount;
  }
}
