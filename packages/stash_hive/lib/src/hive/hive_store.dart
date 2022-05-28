import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';

import 'hive_adapter.dart';

/// Hive based implemention of a [Store]
abstract class HiveStore<T extends BoxBase<Map>, I extends Info,
    E extends Entry<I>> implements Store<I, E> {
  /// The adapter
  final HiveAdapter<T> _adapter;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [HiveStore].
  ///
  /// * [_adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveStore(this._adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  @override
  Future<void> create(String name) {
    return _adapter.create(name);
  }

  @override
  Future<int> size(String name) =>
      Future.value(_adapter.box(name)?.length ?? 0);

  Future<Iterable<String>> _getKeys(String name) {
    return Future.value((_adapter.box(name)?.keys ?? const []).cast<String>());
  }

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  /// Reads a [Entry] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Entry]
  @protected
  E _readEntry(Map<String, dynamic> json);

  /// Gets a [Entry] from the provided [LazyBox]
  ///
  /// * [slot]: The box
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _boxEntry(T slot, String key) =>
      _adapter.boxValue(slot, key).then((value) =>
          value != null ? _readEntry(value.cast<String, dynamic>()) : null);

  /// Returns the box [Entry] for the specified [key].
  ///
  /// * [name]: The box name
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    final box = _adapter.box(name);

    if (box != null) {
      return _boxEntry(box, key);
    }

    return Future<E?>.value();
  }

  /// Returns the box [Info] for the specified [key].
  ///
  /// * [slot]: The box name
  /// * [key]: The key
  ///
  /// Returns a [Info]
  Future<I?> _getInfo(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.info);
  }

  /// Returns a [Iterable] over all the [Info]s for the keys requested
  ///
  /// * [name]: The box name
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

  /// Returns a [Iterable] over all the box [Entry]s
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
  Future<bool> containsKey(String name, String key) =>
      Future.value(_adapter.box(name)?.containsKey(key) ?? false);

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfo(name, key);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _getInfos(name, keys);
  }

  /// Checks if the [value] is one of the base datatypes supported by Hive either returning that value if it is or
  /// invoking toJson to transform it in a supported value
  ///
  /// * [value]: the value to convert
  @protected
  dynamic _toJsonValue(dynamic value) {
    if (value == null ||
        value is bool ||
        value is int ||
        value is double ||
        value is String ||
        value is DateTime ||
        value is BigInt ||
        value is List ||
        value is Map) {
      return value;
    }

    return value.toJson();
  }

  /// Returns the json representation of a [Entry]
  ///
  /// * [entry]: The entry
  ///
  /// Returns the json representation of a [Entry]
  Map<String, dynamic> _writeEntry(E entry);

  @override
  Future<void> setInfo(String name, String key, I info) {
    final box = _adapter.box(name);

    if (box != null) {
      return _boxEntry(box, key).then((entry) {
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
    final box = _adapter.box(name);

    if (box != null) {
      return box.put(key, _writeEntry(entry));
    }

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final box = _adapter.box(name);

    if (box != null) {
      return box.delete(key);
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    final box = _adapter.box(name);

    if (box != null) {
      return box.clear().then((value) => null);
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
    extends HiveStore<T, VaultInfo, VaultEntry> {
  /// Builds a [HiveVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveVaultStore(HiveAdapter<T> adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);

  @override
  VaultEntry _readEntry(Map<String, dynamic> json) {
    return VaultEntry.loadEntry(
        json['key'] as String,
        DateTime.parse(json['creationTime'] as String),
        json['value'] == null
            ? null
            : _fromEncodable != null
                ? _fromEncodable!(
                    (json['value'] as Map).cast<String, dynamic>())
                : json['value'],
        accessTime: json['accessTime'] == null
            ? null
            : DateTime.parse(json['accessTime'] as String),
        updateTime: json['updateTime'] == null
            ? null
            : DateTime.parse(json['updateTime'] as String));
  }

  @override
  Map<String, dynamic> _writeEntry(VaultEntry entry) {
    return <String, dynamic>{
      'key': entry.key,
      'creationTime': entry.creationTime.toIso8601String(),
      'accessTime': entry.accessTime.toIso8601String(),
      'updateTime': entry.updateTime.toIso8601String(),
      'value': _toJsonValue(entry.value),
    };
  }
}

/// The Hive cache store
class HiveCacheStore<T extends BoxBase<Map>>
    extends HiveStore<T, CacheInfo, CacheEntry> {
  /// Builds a [HiveCacheStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveCacheStore(HiveAdapter<T> adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);

  @override
  CacheEntry _readEntry(Map<String, dynamic> json) {
    return CacheEntry.loadEntry(
        json['key'] as String,
        DateTime.parse(json['creationTime'] as String),
        DateTime.parse(json['expiryTime'] as String),
        json['value'] == null
            ? null
            : _fromEncodable != null
                ? _fromEncodable!(
                    (json['value'] as Map).cast<String, dynamic>())
                : json['value'],
        accessTime: json['accessTime'] == null
            ? null
            : DateTime.parse(json['accessTime'] as String),
        updateTime: json['updateTime'] == null
            ? null
            : DateTime.parse(json['updateTime'] as String),
        hitCount: json['hitCount'] as int?);
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
      'value': _toJsonValue(entry.value),
    };
  }
}

/// The default Hive vault store
class HiveDefaultVaultStore extends HiveVaultStore<Box<Map>> {
  /// Builds a [HiveDefaultVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveDefaultVaultStore(HiveDefaultAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}

/// The default Hive cache store
class HiveDefaultCacheStore extends HiveCacheStore<Box<Map>> {
  /// Builds a [HiveDefaultVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveDefaultCacheStore(HiveDefaultAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}

/// The lazy Hive vault store
class HiveLazyVaultStore extends HiveVaultStore<LazyBox<Map>> {
  /// Builds a [HiveLazyVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveLazyVaultStore(HiveLazyAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}

/// The lazy Hive cache store
class HiveLazyCacheStore extends HiveCacheStore<LazyBox<Map>> {
  /// Builds a [HiveLazyCacheStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveLazyCacheStore(HiveLazyAdapter adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);
}
