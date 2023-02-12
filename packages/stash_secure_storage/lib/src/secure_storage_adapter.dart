import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The [SecureStorageAdapter] provides a bridge between the store and the
/// Secure Storage backend
class SecureStorageAdapter {
  // The secure storage backing store
  final FlutterSecureStorage _store;

  /// Set of partitions
  final Set<String> _partitions = {};

  /// [SecureStorageAdapter] constructor
  ///
  /// * [_store]: The [FlutterSecureStorage]
  SecureStorageAdapter._(this._store);

  /// Creates a partition
  ///
  /// * [name]: The partition name
  void create(String name) {
    if (!_partitions.contains(name)) {
      _partitions.add(name);
    }
  }

  /// Returns a map of key values from the secure storage store whose keys that
  /// start with [prefix]
  ///
  /// * [prefix]: the prefix of the keys
  Future<Map<String, String?>> _storeMapByPrefix(String prefix) =>
      _store.readAll().then((map) => {
            for (final key in map.keys)
              if (key.startsWith(prefix)) key: map[key]
          });

  /// Returns all the keys from the secure storage store that start with [prefix]
  ///
  /// * [prefix]: the prefix of the keys
  Future<Iterable<String>> _storeKeysByPrefix(String prefix) =>
      _storeMapByPrefix(prefix).then((map) => map.keys);

  /// Returns the partition prefix
  ///
  /// [name]: the partition name
  String _partitionPrefix(String name) => '${name}_';

  /// Returns all the partitions keys
  ///
  /// * [name]: the partition name
  Future<List<String>> partitionKeys(String name) {
    final partitionPrefix = _partitionPrefix(name);

    return _storeKeysByPrefix(partitionPrefix).then((keys) =>
        keys.map((key) => key.replaceFirst(partitionPrefix, '')).toList());
  }

  /// Returns the partition key
  ///
  /// * [name]: the partition name
  /// * [key]: the key
  String _partitionKey(String name, String key) =>
      '${_partitionPrefix(name)}$key';

  /// Decodes a json [value]
  ///
  /// * [value] the json value
  Map<String, dynamic>? _jsonValue(String? value) =>
      value != null ? json.decode(value) : null;

  /// Returns the partition key value
  ///
  /// * [name]: the partition name
  /// * [key]: the key
  Future<Map<String, dynamic>?> partitionValue(String name, String key) {
    return _store
        .read(key: _partitionKey(name, key))
        .then((value) => _jsonValue(value));
  }

  Future<Map<String, Map<String, dynamic>?>> partitionMap(String name) {
    return _storeMapByPrefix(_partitionPrefix(name))
        .then((map) => {for (final key in map.keys) key: _jsonValue(map[key])});
  }

  /// Checks if a entry exists
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns true if contains a entry with the provided key
  Future<bool> exists(String name, String key) {
    return _store.containsKey(key: _partitionKey(name, key));
  }

  /// Returns the json maps of the provided keys
  ///
  /// * [name]: The partition name
  /// * [keys]: An optional list of keys
  ///
  /// Returns the json map for all or for the selected keys
  Future<List<Map<String, dynamic>?>> partitionValues(String name,
      {Iterable<String>? keys}) {
    if (keys != null) {
      return Future.wait(keys.map((key) => partitionValue(name, key)));
    } else {
      return partitionMap(name).then((map) => map.values.toList());
    }
  }

  /// Adds a value to the partition
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  /// * [value]: The value to set
  ///
  /// Returns the updated value
  Future<void> put(String name, String key, Map<String, dynamic> value) {
    if (_partitions.contains(name)) {
      return _store.write(
          key: _partitionKey(name, key), value: json.encode(value));
    }

    return Future.value();
  }

  /// Removes a entry by key
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<void> remove(String name, String key) {
    if (_partitions.contains(name)) {
      return _store.delete(key: _partitionKey(name, key));
    }

    return Future.value();
  }

  /// Clears a partition
  ///
  /// * [name]: The partition name
  Future<void> clear(String name) {
    return partitionKeys(name)
        .then((keys) => Future.wait(keys.map((key) => remove(name, key))))
        .then((_) => null);
  }

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> _deletePartition(String name) {
    return clear(name).then((value) => _partitions.remove(name));
  }

  /// Deletes a partition from a store or the store itself if a partition is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name) {
    return _deletePartition(name);
  }

  /// Deletes the store if a store is implemented in a way that puts all the
  /// named stashes in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_partitions.map((name) => delete(name)));
  }

  /// Builds a [SecureStorageAdapter].
  ///
  /// * [iOptions]: optional iOS options
  /// * [aOptions]: optional Android options
  /// * [lOptions]: optional Linux options
  /// * [webOptions]: optional web options
  /// * [mOptions]: optional MacOs options
  /// * [wOptions]: optional Windows options
  static Future<SecureStorageAdapter> build(
      {IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WindowsOptions? wOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions}) {
    return Future.value(SecureStorageAdapter._(FlutterSecureStorage(
        iOptions: iOptions ?? IOSOptions.defaultOptions,
        aOptions: aOptions ?? AndroidOptions.defaultOptions,
        lOptions: lOptions ?? LinuxOptions.defaultOptions,
        wOptions: wOptions ?? WindowsOptions.defaultOptions,
        webOptions: webOptions ?? WebOptions.defaultOptions,
        mOptions: mOptions ?? MacOsOptions.defaultOptions)));
  }
}
