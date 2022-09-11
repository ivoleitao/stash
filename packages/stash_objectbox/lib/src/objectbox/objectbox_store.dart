import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/objectbox.g.dart' show PutMode;

import 'cache_entity.dart';
import 'objectbox_adapter.dart';
import 'objectbox_entity.dart';
import 'vault_entity.dart';

/// Objectbox based implemention of a [Store]
abstract class ObjectboxStore<O extends ObjectboxEntity, I extends Info,
    E extends Entry<I>> extends PersistenceStore<I, E> {
  /// The adapter
  final ObjectboxAdapter _adapter;

  /// Builds a [ObjectboxStore].
  ///
  /// * [_adapter]: The objectbox store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  ObjectboxStore(this._adapter, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  @protected
  O _toEntity(E entry);

  @protected
  E? _toEntry(O? entity, dynamic Function(Map<String, dynamic>)? fromEncodable);

  @override
  Future<int> size(String name) =>
      Future.value(_adapter.box<O>(name)?.count() ?? 0);

  /// Returns all the entries on store
  ///
  /// * [name]: The store name
  List<O> _getEntries(String name) {
    return _adapter.box<O>(name)?.getAll() ?? <O>[];
  }

  @override
  Future<Iterable<String>> keys(String name) =>
      Future.value(_getEntries(name).map((entity) => entity.key).toList());

  @override
  Future<Iterable<I>> infos(String name) => Future.value(_getEntries(name)
      .map((entity) => _toEntry(entity, decoder(name))!.info)
      .toList());

  @override
  Future<Iterable<E>> values(String name) =>
      Future.value((_adapter.box<O>(name)?.getAll() ?? [])
          .map((entity) => _toEntry(entity, decoder(name))!)
          .toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      Future.value(_adapter.box<O>(name)?.contains(key.hashCode) ?? false);

  @override
  Future<I?> getInfo(String name, String key) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      return Future.value(_toEntry(box.get(key.hashCode), decoder(name))?.info);
    }

    return Future.value();
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      return Future.value(box
          .getMany(keys.map((key) => key.hashCode).toList())
          .map((entity) => _toEntry(entity, decoder(name))?.info)
          .toList());
    }

    return Future.value(<I?>[]);
  }

  @protected
  void _writeInfo(O entity, I info);

  @override
  Future<void> setInfo(String name, String key, I info) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      final entity = box.get(key.hashCode);
      if (entity != null) {
        _writeInfo(entity, info);
        box.put(entity, mode: PutMode.update);
      }
    }

    return Future.value();
  }

  @override
  Future<E?> getEntry(String name, String key) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      return Future.value(_toEntry(box.get(key.hashCode), decoder(name)));
    }

    return Future<E?>.value();
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      box.put(_toEntity(entry), mode: PutMode.put);
    }
    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      box.remove(key.hashCode);
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      box.removeAll();
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

class ObjectboxVaultStore
    extends ObjectboxStore<VaultEntity, VaultInfo, VaultEntry>
    implements VaultStore {
  ObjectboxVaultStore(super.adapter, {super.codec});

  @override
  VaultEntity _toEntity(VaultEntry entry) {
    final writer = codec.encoder();
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
  VaultEntry? _toEntry(VaultEntity? entity,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    if (entity != null) {
      final reader = codec.decoder(entity.value, fromEncodable: fromEncodable);
      final value = reader.read();

      return VaultEntry.loadEntry(
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
  void _writeInfo(VaultEntity entity, VaultInfo info) {
    entity.accessTime = info.accessTime.toIso8601String();
    entity.updateTime = info.updateTime.toIso8601String();
  }
}

class ObjectboxCacheStore
    extends ObjectboxStore<CacheEntity, CacheInfo, CacheEntry>
    implements CacheStore {
  ObjectboxCacheStore(ObjectboxAdapter adapter, {StoreCodec? codec})
      : super(adapter, codec: codec);

  @override
  CacheEntity _toEntity(CacheEntry entry) {
    final writer = codec.encoder();
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
  CacheEntry? _toEntry(CacheEntity? entity,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    if (entity != null) {
      final reader = codec.decoder(entity.value, fromEncodable: fromEncodable);
      final value = reader.read();

      return CacheEntry.loadEntry(
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
  void _writeInfo(CacheEntity entity, CacheInfo info) {
    entity.expiryTime = info.expiryTime.toIso8601String();
    entity.accessTime = info.accessTime.toIso8601String();
    entity.updateTime = info.updateTime.toIso8601String();
    entity.hitCount = info.hitCount;
  }
}
