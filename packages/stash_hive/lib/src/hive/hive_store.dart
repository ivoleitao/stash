import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';

import 'hive_adapter.dart';

/// Hive based implemention of a [CacheStore]
abstract class HiveStore<T extends BoxBase<Map>, S extends Stat,
    E extends Entry<S>> implements Store<S, E> {
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
  Future<int> size(String name) =>
      _adapter.store(name).then((store) => store.length);

  Future<Iterable<String>> _getKeys(String name) {
    return _adapter.store(name).then((store) => store.keys.cast<String>());
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
  /// * [store]: The Hive box
  /// * [key]: The cache key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntryFromStore(T store, String key) =>
      _adapter.boxValue(store, key).then((value) =>
          value != null ? _readEntry(value.cast<String, dynamic>()) : null);

  /// Returns the [Entry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    return _adapter.store(name).then((store) => _getEntryFromStore(store, key));
  }

  /// Returns the [Stat] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [Stat]
  Future<S?> _getStat(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.stat);
  }

  /// Returns a [Iterable] over all the [CacheStore] [Stat]s keys requested
  /// of a named cache.
  ///
  /// * [name]: The cache name
  /// * [keys]: The list of keys
  ///
  /// Return a list of [CacheStat]s
  Future<Iterable<S?>> _getStats(String name, Iterable<String> keys) {
    return Stream.fromIterable(keys)
        .asyncMap((key) => _getStat(name, key))
        .toList();
  }

  @override
  Future<Iterable<S>> stats(String name) => _getKeys(name)
      .then((keys) => _getStats(name, keys))
      .then((stats) => stats.map((stat) => stat!));

  /// Returns a [Iterable] over all the [CacheStore] [Entry]s
  /// of a named cache.
  ///
  /// * [name]: The cache name
  ///
  /// Return a list of [CacheEntry]s
  Future<Iterable<E>> _getValues(String name) {
    return _getKeys(name).then((keys) => Stream.fromIterable(keys)
        .asyncMap((key) => _getEntry(name, key))
        .map((stat) => stat!)
        .toList());
  }

  @override
  Future<Iterable<E>> values(String name) => _getValues(name);

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.store(name).then((store) => store.containsKey(key));

  @override
  Future<S?> getStat(String name, String key) {
    return _getStat(name, key);
  }

  @override
  Future<Iterable<S?>> getStats(String name, Iterable<String> keys) {
    return _getStats(name, keys);
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
  Future<void> setStat(String name, String key, S stat) {
    return _adapter.store(name).then((store) {
      return _getEntryFromStore(store, key).then((entry) {
        entry!.updateStat(stat);
        store.put(key, _writeEntry(entry));
      });
    });
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _adapter
        .store(name)
        .then((store) => store.put(key, _writeEntry(entry)));
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.store(name).then((store) => store.delete(key));
  }

  @override
  Future<void> clear(String name) {
    return _adapter.store(name).then((store) => store.clear());
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
    extends HiveStore<T, VaultStat, VaultEntry> {
  /// Builds a [HiveVaultStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveVaultStore(HiveAdapter<T> adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);

  @override
  VaultEntry _readEntry(Map<String, dynamic> json) {
    return VaultEntry.newEntry(
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
    extends HiveStore<T, CacheStat, CacheEntry> {
  /// Builds a [HiveCacheStore].
  ///
  /// * [adapter]: The hive store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  HiveCacheStore(HiveAdapter<T> adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, fromEncodable: fromEncodable);

  @override
  CacheEntry _readEntry(Map<String, dynamic> json) {
    return CacheEntry.newEntry(
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
