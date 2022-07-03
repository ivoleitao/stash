import 'package:meta/meta.dart';
import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';
import 'package:stash/stash_api.dart';

import 'sembast_adapter.dart';

/// Sembast based implemention of a [Store]
abstract class SembastStore<I extends Info, E extends Entry<I>>
    extends PersistenceStore<I, E> {
  /// The adapter
  final SembastAdapter _adapter;

  /// Builds a [SembastStore].
  ///
  /// * [_adapter]: The sembast store adapter
  SembastStore(this._adapter);

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  @override
  Future<int> size(String name) => _adapter.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _adapter.keys(name);

  /// Reads a [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  @protected
  E _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable);

  /// Retrieves a [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  E? _getEntryFromValue(Map<String, dynamic>? value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return value != null ? _readEntry(value, fromEncodable) : null;
  }

  /// Retrieves a [Info] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Info]
  I? _getInfoFromValue(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return _getEntryFromValue(value, fromEncodable)?.info;
  }

  /// Gets an [Entry] by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  ///  Returns the corresponding [Entry]
  Future<E?> _getEntryFromStore(String name, String key) => _adapter
      .getByKey(name, key)
      .then((value) => _getEntryFromValue(value, decoder(name)));

  /// Returns the [Entry] for the named value specified [key].
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    return _getEntryFromStore(name, key);
  }

  /// Gets the list of all the records by store name
  ///
  /// * [name]: The store name
  ///
  ///  Returns the list of [RecordSnapshot]'s by cache name
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> _getRecords(
      String name) {
    return _adapter.find(name);
  }

  @override
  Future<Iterable<I>> infos(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getInfoFromValue(record.value, decoder(name)))
          .map((info) => info!)
          .toList());

  @override
  Future<Iterable<E>> values(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getEntryFromValue(record.value, decoder(name)))
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
    return _adapter.getByKeys(name, keys).then((records) => records
        .map((record) => _getEntryFromValue(record, decoder(name))?.info)
        .toList());
  }

  /// Checks if the [value] is one of the base datatypes supported by Sembast
  /// either returning that value if it is or invoking toJson to transform it
  /// in a supported value
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
      if (entry != null) {
        entry.updateInfo(info);
        return _adapter
            .put(name, key, _writeEntry(entry))
            .then((value) => null);
      }
      return Future<void>.value();
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
  SembastVaultStore(super.adapter);

  @override
  VaultEntry _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return VaultEntry.loadEntry(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        decodeValue(value['value'], fromEncodable,
            mapFn: (source) => (source as Map).cast<String, dynamic>()),
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
      'value': _toJsonValue(entry.value),
    };
  }
}

class SembastCacheStore extends SembastStore<CacheInfo, CacheEntry> {
  /// Builds a [SembastCacheStore].
  ///
  /// * [_adapter]: The sembast store adapter
  SembastCacheStore(super.adapter);

  @override
  CacheEntry _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return CacheEntry.loadEntry(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        DateTime.parse(value['expiryTime'] as String),
        decodeValue(value['value'], fromEncodable,
            mapFn: (source) => (source as Map).cast<String, dynamic>()),
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
      'value': _toJsonValue(entry.value),
    };
  }
}
