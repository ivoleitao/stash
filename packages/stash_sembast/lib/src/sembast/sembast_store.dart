import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
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
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SembastStore(this._adapter, {super.codec});

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

  /// Reads a [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  @protected
  I _readInfo(Map<String, dynamic> value);

  /// Reads a nullable [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  I? _readNullableInfo(Map<String, dynamic>? value) {
    return value != null ? _readInfo(value) : null;
  }

  /// Reads a [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  @protected
  E _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable);

  /// Reads a nullable [Entry] from a json map
  ///
  /// * [value]: The json map
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  ///  Returns the corresponding [Entry]
  E? _readNullableEntry(Map<String, dynamic>? value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return value != null ? _readEntry(value, fromEncodable) : null;
  }

  /// Gets an [Info] by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  ///  Returns the corresponding [Info]
  Future<I?> _getInfo(String name, String key) => _adapter
      .partitionValue(name, key)
      .then((value) => _readNullableInfo(value));

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfo(name, key);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _adapter.getByKeys(name, keys).then((records) =>
        records.map((record) => _readNullableInfo(record)).toList());
  }

  @override
  Future<Iterable<I>> infos(String name) =>
      _partitionRecords(name).then((records) => records
          .map((record) => _readNullableInfo(record.value))
          .whereType<I>()
          .toList());

  /// Gets an [Entry] by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  ///  Returns the corresponding [Entry]
  Future<E?> _partitionEntry(String name, String key) => _adapter
      .partitionValue(name, key)
      .then((value) => _readNullableEntry(value, decoder(name)));

  /// Returns the [Entry] for the named value specified [key].
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  /// Returns a [Entry]
  Future<E?> _getEntry(String name, String key) {
    return _partitionEntry(name, key);
  }

  /// Gets the list of all the records by store name
  ///
  /// * [name]: The store name
  ///
  ///  Returns the list of [RecordSnapshot]'s by cache name
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> _partitionRecords(
      String name) {
    return _adapter.find(name);
  }

  @override
  Future<Iterable<E>> values(String name) => _partitionRecords(name)
      .then((records) => records
          .map((record) => _readNullableEntry(record.value, decoder(name))))
      .then((values) => values.whereType<E>());

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.exists(name, key);

  /// Returns the json representation of an [Entry]
  ///
  /// * [entry]: The entry
  ///
  /// Returns the json representation of a [Entry]
  @protected
  Map<String, dynamic> _writeEntry(E entry);

  @override
  Future<void> setInfo(String name, String key, I info) {
    return _partitionEntry(name, key).then((entry) {
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

  @override
  Future<void> close() {
    return _adapter.close();
  }
}

class SembastVaultStore extends SembastStore<VaultInfo, VaultEntry>
    implements VaultStore {
  /// Builds a [SembastVaultStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SembastVaultStore(super.adapter, {super.codec});

  @override
  VaultInfo _readInfo(Map<String, dynamic> value) {
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
  VaultEntry _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return VaultEntry.loaded(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        decodeValue(value['value'], fromEncodable,
            processor: ValueProcessor.cast),
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
      'value': encodeValue(entry.value)
    };
  }
}

class SembastCacheStore extends SembastStore<CacheInfo, CacheEntry>
    implements CacheStore {
  /// Builds a [SembastCacheStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SembastCacheStore(super.adapter, {super.codec});

  @override
  CacheInfo _readInfo(Map<String, dynamic> value) {
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
  CacheEntry _readEntry(Map<String, dynamic> value,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return CacheEntry.loaded(
        value['key'] as String,
        DateTime.parse(value['creationTime'] as String),
        DateTime.parse(value['expiryTime'] as String),
        decodeValue(value['value'], fromEncodable,
            processor: ValueProcessor.cast),
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
      'value': encodeValue(entry.value)
    };
  }
}
