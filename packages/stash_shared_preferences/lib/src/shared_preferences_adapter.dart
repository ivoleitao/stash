import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// The [SharedPreferencesAdapter] provides a bridge between the store and the
/// Shared Prefererences backend
class SharedPreferencesAdapter {
  // The preferences backing store
  final SharedPreferences _prefs;

  /// Set of partitions
  final Set<String> _partitions = {};

  /// [SharedPreferencesAdapter] constructor
  ///
  /// * [_prefs]: The [SharedPreferences]
  SharedPreferencesAdapter._(this._prefs);

  /// Creates a partition
  ///
  /// * [name]: The partition name
  void create(String name) {
    if (!_partitions.contains(name)) {
      _partitions.add(name);
    }
  }

  /// Returns all the keys from the preference store that start with [prefix]
  ///
  /// * [prefix]: the prefix of the keys
  Iterable<String> _preferenceKeysByPrefix(String prefix) =>
      _prefs.getKeys().where((key) => key.startsWith(prefix));

  /// Returns the partition prefix
  ///
  /// [name]: the partition name
  String _partitionPrefix(String name) => '${name}_';

  /// Returns all the partitions keys
  ///
  /// * [name]: the partition name
  List<String> partitionKeys(String name) {
    final partitionPrefix = _partitionPrefix(name);

    return _preferenceKeysByPrefix(partitionPrefix)
        .map((key) => key.replaceFirst(partitionPrefix, ''))
        .toList();
  }

  /// Returns the partition key
  ///
  /// * [name]: the partition name
  /// * [key]: the key
  String _partitionKey(String name, String key) =>
      '${_partitionPrefix(name)}$key';

  /// Returns the partition key value
  ///
  /// * [name]: the partition name
  /// * [key]: the key
  Future<Map<String, dynamic>?> partitionValue(String name, String key) {
    final value = _prefs.getString(_partitionKey(name, key));

    if (value != null) {
      return Future.value(json.decode(value));
    }

    return Future.value();
  }

  /// Checks if a entry exists
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns true if contains a entry with the provided key
  Future<bool> exists(String name, String key) {
    return Future.value(_prefs.containsKey(_partitionKey(name, key)));
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
      return Future.wait(partitionKeys(name).map((key) {
        return partitionValue(name, key);
      })).then((values) => values.whereType<Map<String, dynamic>>().toList());
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
      return _prefs
          .setString(_partitionKey(name, key), json.encode(value))
          .then((_) => null);
    }

    return Future.value();
  }

  /// Removes a entry by key
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<void> remove(String name, String key) {
    if (_partitions.contains(name)) {
      return _prefs.remove(_partitionKey(name, key)).then((_) => null);
    }

    return Future.value();
  }

  /// Clears a partition
  ///
  /// * [name]: The partition name
  Future<void> clear(String name) {
    return Future.wait(partitionKeys(name).map((key) => remove(name, key)));
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

  /// Builds a [SharedPreferencesAdapter].
  static Future<SharedPreferencesAdapter> build() {
    return SharedPreferences.getInstance()
        .then((prefs) => SharedPreferencesAdapter._(prefs));
  }
}
