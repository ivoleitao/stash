import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_isar/src/isar/entry_model.dart';

import 'cache_model.dart';
import 'isar_adapter.dart';
import 'vault_model.dart';

/// Isar based implemention of a [Store]
abstract class IsarStore<M extends EntryModel, I extends Info,
    E extends Entry<I>> extends PersistenceStore<I, E> {
  /// The adapter
  final IsarAdapter<M> _adapter;

  /// Builds a [IsarStore].
  ///
  /// * [_adapter]: The isar store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  IsarStore(this._adapter, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  @override
  Future<int> size(String name) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return partition.count();
    }

    return Future.value(0);
  }

  @protected
  QueryBuilder<M, String, QQueryOperations> keyProperty(
      IsarCollection<M> collection);

  Future<Iterable<String>> _getKeys(String name) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return keyProperty(partition).findAll();
    }

    return Future.value(<String>[]);
  }

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  @protected
  QueryBuilder<M, M, QAfterWhereClause> keyQuery(
      IsarCollection<M> collection, String key);

  /// Encodes a value into a list of bytes
  ///
  /// * [value]: The value to encode
  ///
  /// Returns the value encoded as a list of bytes
  @protected
  Uint8List valueEncoder(dynamic value) {
    final writer = codec.encoder();

    writer.write(value);

    return writer.takeBytes();
  }

  /// Returns a value decoded from the provided list of bytes
  ///
  /// * [bytes]: The list of bytes
  /// * [fromEncodable]: An function that converts between the Map representation and the object
  ///
  /// Returns the decoded value from the list of bytes
  @protected
  dynamic valueDecoder(
      Uint8List bytes, dynamic Function(Map<String, dynamic>)? fromEncodable) {
    final reader = codec.decoder(bytes, fromEncodable: fromEncodable);

    return reader.read();
  }

  @protected
  E toEntry(M model, dynamic Function(Map<String, dynamic>)? fromEncodable);

  E? toEntryOptional(
          M? model, dynamic Function(Map<String, dynamic>)? fromEncodable) =>
      model != null ? toEntry(model, fromEncodable) : null;

  @protected
  M fromEntry(E entry);

  @protected
  M? fromEntryOptional(E? entry) => entry != null ? fromEntry(entry) : null;

  /// Returns the partition [Entry] for the specified [key].
  ///
  /// * [name]: The partition
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<M?> _partitionModel(IsarCollection<M> partition, String key) =>
      keyQuery(partition, key).findFirst();

  /// Returns the partition [Entry] for the specified [key].
  ///
  /// * [name]: The partition
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _partitionEntry(IsarCollection<M> partition, String key,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return _partitionModel(partition, key)
        .then((model) => toEntryOptional(model, fromEncodable));
  }

  /// Returns the [Entry] for the specified [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return _partitionEntry(partition, key, decoder(name));
    }

    return Future<E?>.value();
  }

  /// Returns the [Info] for the specified [key].
  ///
  /// * [slot]: The partition name
  /// * [key]: The key
  ///
  /// Returns a [Info]
  Future<I?> _getInfo(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.info);
  }

  /// Returns a [Iterable] over all the [Info]s for the keys requested
  ///
  /// * [name]: The partition name
  /// * [keys]: The list of keys
  ///
  /// Return a list of [CacheInfo]s
  Future<Iterable<I?>> _getInfos(String name, Iterable<String> keys) {
    return Stream.fromIterable(keys)
        .asyncMap((key) => _getInfo(name, key))
        .toList();
  }

  @override
  Future<Iterable<I>> infos(String name) => _getKeys(name)
      .then((keys) => _getInfos(name, keys))
      .then((infos) => infos.map((info) => info!));

  /// Returns a [Iterable] over all the [Entry]s
  ///
  /// * [name]: The box name
  ///
  /// Return a list of [Entry]s
  Future<Iterable<E>> _getValues(String name) {
    return _getKeys(name).then((keys) => Stream.fromIterable(keys)
        .asyncMap((key) => _getEntry(name, key))
        .map((info) => info!)
        .toList());
  }

  @override
  Future<Iterable<E>> values(String name) => _getValues(name);

  @override
  Future<bool> containsKey(String name, String key) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return keyProperty(partition).findFirst().then((model) => model != null);
    }

    return Future.value(false);
  }

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfo(name, key);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _getInfos(name, keys);
  }

  @override
  Future<void> setInfo(String name, String key, I info) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return _partitionEntry(partition, key, decoder(name)).then((entry) {
        if (entry != null) {
          final model = fromEntry(entry..updateInfo(info));

          return partition.isar.writeTxn(() => partition.put(model));
        }

        return Future.value();
      });
    }

    return Future.value();
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return _partitionModel(partition, key).then((model) {
        if (model != null) {
          return partition.isar.writeTxn(() =>
              partition.put(fromEntry(entry)..id = model.id).then((_) => null));
        } else {
          return partition.isar.writeTxn(
              () => partition.put(fromEntry(entry)).then((_) => null));
        }
      });
    }

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return _partitionModel(partition, key).then((model) {
        final id = model?.id;

        if (id != null) {
          return partition.isar
              .writeTxn(() => partition.delete(id).then((_) => null));
        }

        return Future.value();
      });
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return partition.clear();
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

/// The Isar vault store
class IsarVaultStore extends IsarStore<VaultModel, VaultInfo, VaultEntry> {
  /// Builds a [IsarVaultStore].
  ///
  /// * [adapter]: The isar store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  IsarVaultStore(super.adapter, {super.codec});

  @override
  QueryBuilder<VaultModel, String, QQueryOperations> keyProperty(
      IsarCollection<VaultModel> collection) {
    return collection.where().keyProperty();
  }

  @override
  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> keyQuery(
      IsarCollection<VaultModel> collection, String key) {
    return collection.where().keyEqualTo(key);
  }

  @override
  VaultEntry toEntry(
      VaultModel model, dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return VaultEntry.loadEntry(
        model.key, model.creationTime, valueDecoder(model.value, fromEncodable),
        accessTime: model.accessTime, updateTime: model.updateTime);
  }

  @override
  VaultModel fromEntry(VaultEntry entry) {
    return VaultModel()
      ..key = entry.key
      ..creationTime = entry.creationTime
      ..value = valueEncoder(entry.value)
      ..accessTime = entry.accessTime
      ..updateTime = entry.updateTime;
  }
}

/// The Isar cache store
class IsarCacheStore extends IsarStore<CacheModel, CacheInfo, CacheEntry> {
  /// Builds a [IsarCacheStore].
  ///
  /// * [adapter]: The isar store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  IsarCacheStore(super.adapter, {super.codec});

  @override
  QueryBuilder<CacheModel, String, QQueryOperations> keyProperty(
      IsarCollection<CacheModel> collection) {
    return collection.where().keyProperty();
  }

  @override
  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> keyQuery(
      IsarCollection<CacheModel> collection, String key) {
    return collection.where().keyEqualTo(key);
  }

  @override
  CacheEntry toEntry(
      CacheModel model, dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return CacheEntry.loadEntry(model.key, model.creationTime, model.expiryTime,
        valueDecoder(model.value, fromEncodable),
        accessTime: model.accessTime,
        updateTime: model.updateTime,
        hitCount: model.hitCount);
  }

  @override
  CacheModel fromEntry(CacheEntry entry) {
    return CacheModel()
      ..key = entry.key
      ..creationTime = entry.creationTime
      ..expiryTime = entry.expiryTime
      ..accessTime = entry.accessTime
      ..updateTime = entry.updateTime
      ..hitCount = entry.hitCount
      ..value = valueEncoder(entry.value);
  }
}
