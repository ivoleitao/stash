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

  @protected
  I? _readInfo(O? entity);

  @protected
  O _toEntity(E entry);

  @protected
  E? _readEntry(
      O? entity, dynamic Function(Map<String, dynamic>)? fromEncodable);

  @override
  Future<Iterable<I>> infos(String name) => Future.value(_getEntries(name)
      .map((entity) => _readInfo(entity))
      .whereType<I>()
      .toList());

  @override
  Future<Iterable<E>> values(String name) => Future.value(_getEntries(name)
      .map((entity) => _readEntry(entity, decoder(name)))
      .whereType<E>()
      .toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      Future.value(_adapter.box<O>(name)?.contains(key.hashCode) ?? false);

  @override
  Future<I?> getInfo(String name, String key) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      return Future.value(_readInfo(box.get(key.hashCode)));
    }

    return Future.value();
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    final box = _adapter.box<O>(name);

    if (box != null) {
      return Future.value(box
          .getMany(keys.map((key) => key.hashCode).toList())
          .map((entity) => _readInfo(entity))
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
      return Future.value(_readEntry(box.get(key.hashCode), decoder(name)));
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

  @override
  Future<void> close() {
    return _adapter.close();
  }
}

class ObjectboxVaultStore
    extends ObjectboxStore<VaultEntity, VaultInfo, VaultEntry>
    implements VaultStore {
  ObjectboxVaultStore(super.adapter, {super.codec});

  @override
  VaultEntity _toEntity(VaultEntry entry) {
    return VaultEntity(
        id: entry.key.hashCode,
        key: entry.key,
        value: encodeValue(entry.value),
        creationTime: entry.creationTime.toIso8601String(),
        accessTime: entry.accessTime.toIso8601String(),
        updateTime: entry.updateTime.toIso8601String());
  }

  @override
  VaultInfo? _readInfo(VaultEntity? entity) {
    if (entity != null) {
      return VaultInfo(entity.key, DateTime.parse(entity.creationTime),
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
  VaultEntry? _readEntry(VaultEntity? entity,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    if (entity != null) {
      return VaultEntry.loaded(entity.key, DateTime.parse(entity.creationTime),
          decodeValue(entity.value, fromEncodable),
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
  ObjectboxCacheStore(super.adapter, {super.codec});

  @override
  CacheEntity _toEntity(CacheEntry entry) {
    return CacheEntity(
        id: entry.key.hashCode,
        key: entry.key,
        value: encodeValue(entry.value),
        expiryTime: entry.expiryTime.toIso8601String(),
        creationTime: entry.creationTime.toIso8601String(),
        accessTime: entry.accessTime.toIso8601String(),
        updateTime: entry.updateTime.toIso8601String(),
        hitCount: entry.hitCount);
  }

  @override
  CacheInfo? _readInfo(CacheEntity? entity) {
    if (entity != null) {
      return CacheInfo(entity.key, DateTime.parse(entity.creationTime),
          DateTime.parse(entity.expiryTime),
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
  CacheEntry? _readEntry(CacheEntity? entity,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    if (entity != null) {
      return CacheEntry.loaded(
          entity.key,
          DateTime.parse(entity.creationTime),
          DateTime.parse(entity.expiryTime),
          decodeValue(entity.value, fromEncodable),
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
