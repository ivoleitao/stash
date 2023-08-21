//import 'package:secure_storage/secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';

import 'secure_storage_adapter.dart';

/// Shared Preferences based implemention of a [Store]
abstract class SecureStorageStore<I extends Info, E extends Entry<I>>
    extends PersistenceStore<I, E> {
  /// The adapter
  final SecureStorageAdapter _adapter;

  /// Builds a [SecureStorageStore].
  ///
  /// * [_adapter]: The shared preferences adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SecureStorageStore(this._adapter, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  /// Returns a list of keys in the partition
  ///
  /// * [name]: The name of the partition
  ///
  /// Returns the list of keys in the partition
  Future<Iterable<String>> _getKeys(String name) =>
      Future.value(_adapter.partitionKeys(name));

  @override
  Future<int> size(String name) => _getKeys(name).then((it) => it.length);

  @override
  Future<Iterable<String>> keys(String name) => _getKeys(name);

  /// Reads a [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  @protected
  I _readInfo(Map<String, dynamic> value);

  /// Retrieves a [Info] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [Info]
  I? _getInfoFromValue(Map<String, dynamic>? value) {
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

  /// Gets an [Entry] by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  ///  Returns the corresponding [Entry]
  Future<E?> _getEntryFromStore(String name, String key) => _adapter
      .partitionValue(name, key)
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

  @override
  Future<Iterable<I>> infos(String name) => _adapter
      .partitionValues(name)
      .then((values) => values.map((value) => _getInfoFromValue(value)))
      .then((values) => values.whereType<I>());

  @override
  Future<Iterable<E>> values(String name) => _adapter
      .partitionValues(name)
      .then((values) =>
          values.map((value) => _getEntryFromValue(value, decoder(name))))
      .then((values) => values.whereType<E>());

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.exists(name, key);

  /// Gets an [Info] by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  ///  Returns the corresponding [Info]
  Future<I?> _getInfoFromStore(String name, String key) => _adapter
      .partitionValue(name, key)
      .then((value) => _getInfoFromValue(value));

  @override
  Future<I?> getInfo(String name, String key) {
    return _getInfoFromStore(name, key);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _adapter.partitionValues(name, keys: keys).then((records) =>
        records.map((record) => _getInfoFromValue(record)).toList());
  }

  /// Returns the json representation of an [Entry]
  ///
  /// * [entry]: The entry
  ///
  /// Returns the json representation of a [Entry]
  @protected
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

class SecureStorageVaultStore extends SecureStorageStore<VaultInfo, VaultEntry>
    implements VaultStore {
  /// Builds a [SecureStorageVaultStore].
  ///
  /// * [adapter]: The secure storage store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SecureStorageVaultStore(super.adapter, {super.codec});

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

class SecureStorageCacheStore extends SecureStorageStore<CacheInfo, CacheEntry>
    implements CacheStore {
  /// Builds a [SecureStorageCacheStore].
  ///
  /// * [adapter]: The secure storage store adapter
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SecureStorageCacheStore(super.adapter, {super.codec});

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
