import 'package:meta/meta.dart';
import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';
import 'package:stash/stash_api.dart';

import 'sembast_adapter.dart';

/// Sembast based implemention of a [Store]
abstract class SembastStore<I extends Info, E extends Entry<I>>
    implements Store<I, E> {
  /// The adapter
  final SembastAdapter _adapter;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [SembastStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SembastStore(this._adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  @override
  Future<int> size(String name) => _adapter.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _adapter.keys(name);

  /// Reads a [Entry] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Entry]
  @protected
  E _readEntry(Map<String, dynamic> json);

  /// Retrieves a [Entry] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Entry]
  E? _getEntryFromValue(Map<String, dynamic>? value) {
    return value != null ? _readEntry(value) : null;
  }

  /// Retrieves a [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  I? _getInfoFromValue(Map<String, dynamic> value) {
    return _getEntryFromValue(value)?.info;
  }

  /// Calls the [CacheDao] and retries a [Entry] by key
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  ///  Returns the corresponding [Entry]
  Future<E?> _getEntryFromStore(String name, String key) =>
      _adapter.getByKey(name, key).then(_getEntryFromValue);

  /// Returns the [Entry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    return _getEntryFromStore(name, key);
  }

  /// Gets the list of all the records by cache name
  ///
  /// * [name]: The name of the cache
  ///
  ///  Returns the list of [RecordSnapshot]'s by cache name
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> _getRecords(
      String name) {
    return _adapter.find(name);
  }

  @override
  Future<Iterable<I>> infos(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getInfoFromValue(record.value))
          .map((info) => info!)
          .toList());

  @override
  Future<Iterable<E>> values(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getEntryFromValue(record.value))
          .map((entry) => entry!)
          .toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.exists(name, key);

  @override
  Future<I?> getInfo(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.info);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _adapter.getByKeys(name, keys).then((records) =>
        records.map((record) => _getEntryFromValue(record)?.info).toList());
  }

  /// Checks if the [value] is one of the base datatypes supported by Sembast either returning that value if it is or
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
        value is Blob ||
        value is Timestamp ||
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
    return _getEntryFromStore(name, key).then((entry) {
      entry!.updateInfo(info);
      _adapter.put(name, key, _writeEntry(entry));
    });
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _adapter.put(name, key, _writeEntry(entry));
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.remove(name, key);
  }

  @override
  Future<void> clear(String name) {
    return _adapter.clear(name);
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

class SembastVaultStore extends SembastStore<VaultInfo, VaultEntry> {
  /// Builds a [SembastVaultStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SembastVaultStore(SembastAdapter _adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(_adapter, fromEncodable: fromEncodable);

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

class SembastCacheStore extends SembastStore<CacheInfo, CacheEntry> {
  /// Builds a [SembastCacheStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SembastCacheStore(SembastAdapter _adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(_adapter, fromEncodable: fromEncodable);

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
