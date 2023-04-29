import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';

import 'hive_adapter.dart';

/// Hive based implemention of a [Store]
abstract class HiveStore<T extends BoxBase<Map>, I extends Info,
    E extends Entry<I>> extends PersistenceStore<I, E> {
  /// The adapter
  final HiveAdapter<T> _adapter;

  /// Builds a [HiveStore].
  ///
  /// * [_adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveStore(this._adapter, {super.codec});

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
      return Future.value(partition.length);
    }

    return Future.value(0);
  }

  /// Reads the keys of a partition
  ///
  /// * [name]: The partition name
  ///
  ///  Returns the keys
  Future<Iterable<String>> _getKeys(String name) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return Future.value(partition.keys.cast<String>());
    }

    return Future.value(const <String>[]);
  }

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  /// Reads a [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  @protected
  I _readInfo(Map<dynamic, dynamic> value);

  /// Reads a nullable [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  I? _readNullableInfo(Map<dynamic, dynamic>? value) =>
      value != null ? _readInfo(value) : null;

  /// Reads a [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  @protected
  E _readEntry(Map<dynamic, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable);

  /// Reads a nullable [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  E? _readNullableEntry(Map<dynamic, dynamic>? value,
          dynamic Function(Map<String, dynamic>)? fromEncodable) =>
      value != null ? _readEntry(value, fromEncodable) : null;

  /// Gets a [Info] from the provided [BoxBase]
  ///
  /// * [partition]: The partition
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<I?> _partitionInfo(T partition, String key) => _adapter
      .partitionValue(partition, key)
      .then((value) => _readNullableInfo(value));

  /// Returns the box [Info] for the specified [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns a [Info]
  Future<I?> _getInfo(String name, String key) {
    final box = _adapter.partition(name);

    if (box != null) {
      return _partitionInfo(box, key);
    }

    return Future<I?>.value();
  }

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfo(name, key);
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
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _getInfos(name, keys);
  }

  @override
  Future<Iterable<I>> infos(String name) => _getKeys(name)
      .then((keys) => _getInfos(name, keys))
      .then((infos) => infos.map((info) => info!));

  /// Gets a [Entry] from the provided [LazyBox]
  ///
  /// * [name]: The partition name
  /// * [partition]: The box
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _partitionEntry(String name, T partition, String key) => _adapter
      .partitionValue(partition, key)
      .then((value) => _readNullableEntry(value, decoder(name)));

  /// Returns the box [Entry] for the specified [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    final box = _adapter.partition(name);

    if (box != null) {
      return _partitionEntry(name, box, key);
    }

    return Future<E?>.value();
  }

  /// Returns a [Iterable] over all the box [Entry]s
  ///
  /// * [name]: The partition name
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
  Future<bool> containsKey(String name, String key) =>
      Future.value(_adapter.partition(name)?.containsKey(key) ?? false);

  /// Returns the json representation of a [Entry]
  ///
  /// * [entry]: The entry
  ///
  /// Returns the json representation of a [Entry]
  Map<String, dynamic> _writeEntry(E entry);

  @override
  Future<void> setInfo(String name, String key, I info) {
    final box = _adapter.partition(name);

    if (box != null) {
      return _partitionEntry(name, box, key).then((entry) {
        if (entry != null) {
          entry.updateInfo(info);
          return box.put(key, _writeEntry(entry));
        }

        return Future<void>.value();
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
    final box = _adapter.partition(name);

    if (box != null) {
      return box.put(key, _writeEntry(entry));
    }

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return partition.delete(key);
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    final partition = _adapter.partition(name);

    if (partition != null) {
      return partition.clear().then((value) => null);
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

/// The Hive vault store
class HiveVaultStore<T extends BoxBase<Map>>
    extends HiveStore<T, VaultInfo, VaultEntry> implements VaultStore {
  /// Builds a [HiveVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveVaultStore(super.adapter, {super.codec});

  @override
  VaultInfo _readInfo(Map<dynamic, dynamic> value) {
    return VaultInfo(
        value['key'] as String, DateTime.parse(value['creationTime'] as String),
        accessTime: value['accessTime'] == null
            ? null
            : DateTime.parse(value['accessTime'] as String),
        updateTime: value['updateTime'] == null
            ? null
            : DateTime.parse(value['updateTime'] as String));
  }

  @override
  VaultEntry _readEntry(Map<dynamic, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return VaultEntry.loaded(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        valueDecoder(Uint8List.fromList(value['value']), fromEncodable),
        accessTime: value['accessTime'] == null
            ? null
            : DateTime.parse(value['accessTime'] as String),
        updateTime: value['updateTime'] == null
            ? null
            : DateTime.parse(value['updateTime'] as String));
  }

  @override
  Map<String, dynamic> _writeEntry(VaultEntry entry) {
    return <String, dynamic>{
      'key': entry.key,
      'creationTime': entry.creationTime.toIso8601String(),
      'accessTime': entry.accessTime.toIso8601String(),
      'updateTime': entry.updateTime.toIso8601String(),
      'value': valueEncoder(entry.value),
    };
  }
}

/// The Hive cache store
class HiveCacheStore<T extends BoxBase<Map>>
    extends HiveStore<T, CacheInfo, CacheEntry> implements CacheStore {
  /// Builds a [HiveCacheStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveCacheStore(super.adapter, {super.codec});

  @override
  CacheInfo _readInfo(Map<dynamic, dynamic> value) {
    return CacheInfo(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        DateTime.parse(value['expiryTime'] as String),
        accessTime: value['accessTime'] == null
            ? null
            : DateTime.parse(value['accessTime'] as String),
        updateTime: value['updateTime'] == null
            ? null
            : DateTime.parse(value['updateTime'] as String),
        hitCount: value['hitCount'] as int?);
  }

  @override
  CacheEntry _readEntry(Map<dynamic, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return CacheEntry.loaded(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        DateTime.parse(value['expiryTime'] as String),
        valueDecoder(Uint8List.fromList(value['value']), fromEncodable),
        accessTime: value['accessTime'] == null
            ? null
            : DateTime.parse(value['accessTime'] as String),
        updateTime: value['updateTime'] == null
            ? null
            : DateTime.parse(value['updateTime'] as String),
        hitCount: value['hitCount'] as int?);
  }

  @override
  Map<String, dynamic> _writeEntry(CacheEntry entry) {
    return <String, dynamic>{
      'key': entry.key,
      'expiryTime': entry.expiryTime.toIso8601String(),
      'creationTime': entry.creationTime.toIso8601String(),
      'accessTime': entry.accessTime.toIso8601String(),
      'updateTime': entry.updateTime.toIso8601String(),
      'hitCount': entry.hitCount,
      'value': valueEncoder(entry.value),
    };
  }
}

/// The default Hive vault store
class HiveDefaultVaultStore extends HiveVaultStore<Box<Map>> {
  /// Builds a [HiveDefaultVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveDefaultVaultStore(super.adapter, {super.codec});
}

/// The default Hive cache store
class HiveDefaultCacheStore extends HiveCacheStore<Box<Map>> {
  /// Builds a [HiveDefaultVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveDefaultCacheStore(super.adapter, {super.codec});
}

/// The lazy Hive vault store
class HiveLazyVaultStore extends HiveVaultStore<LazyBox<Map>> {
  /// Builds a [HiveLazyVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveLazyVaultStore(super.adapter, {super.codec});
}

/// The lazy Hive cache store
class HiveLazyCacheStore extends HiveCacheStore<LazyBox<Map>> {
  /// Builds a [HiveLazyCacheStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  HiveLazyCacheStore(super.adapter, {super.codec});
}
