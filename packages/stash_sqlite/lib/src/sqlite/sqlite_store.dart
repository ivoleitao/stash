import 'dart:typed_data';

import 'package:stash/stash_api.dart';

import 'sqlite_adapter.dart';

/// Sqlite based implemention of a [Store]
class SqliteStore<I extends Info, E extends Entry<I>>
    extends PersistenceStore<I, E> {
  /// The adapter
  final SqliteAdapter<I, E> _adapter;

  /// Builds a [SqliteStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SqliteStore(this._adapter, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  @override
  Future<int> size(String name) => _adapter.dao.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _adapter.dao.keys(name);

  @override
  Future<Iterable<I>> infos(String name) => _adapter.dao.infos(name);

  /// Returns a value decoded from the provided list of bytes
  ///
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  ///
  /// Returns the decoded value from the list of bytes
  dynamic Function(Uint8List) _valueDecoder(
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    dynamic valueDecoder(Uint8List bytes) {
      var reader = codec.decoder(bytes, fromEncodable: fromEncodable);

      return reader.read();
    }

    return valueDecoder;
  }

  @override
  Future<Iterable<E>> values(String name) =>
      _adapter.dao.entries(name, _valueDecoder(decoder(name)));

  @override
  Future<bool> containsKey(String name, String key) {
    return _adapter.dao.containsKey(name, key);
  }

  @override
  Future<I> getInfo(String name, String key) {
    return _adapter.dao.getInfo(name, key);
  }

  @override
  Future<Iterable<I>> getInfos(String name, Iterable<String> keys) {
    return _adapter.dao.getInfos(name, keys);
  }

  @override
  Future<void> setInfo(String name, String key, I info) {
    return _adapter.dao.updateInfo(name, info);
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _adapter.dao.getEntry(name, key, _valueDecoder(decoder(name)));
  }

  /// Encodes a value into a list of bytes
  ///
  /// * [value]: The value to encode
  ///
  /// Returns the value encoded as a list of bytes
  Uint8List _valueEncoder(dynamic value) {
    var writer = codec.encoder();

    writer.write(value);

    return writer.takeBytes();
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _adapter.dao.putEntry(name, entry, _valueEncoder);
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.dao.remove(name, key);
  }

  @override
  Future<void> clear(String name) {
    return _adapter.dao.clear(name);
  }

  @override
  Future<void> delete(String name) {
    return _adapter.dao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return _adapter.dao.clearAll();
  }
}

/// Sqlite based implemention of a Vault [Store]
class SqliteVaultStore extends SqliteStore<VaultInfo, VaultEntry> {
  /// Builds a [SqliteVaultStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SqliteVaultStore(super.adapter, {super.codec});
}

/// Sqlite based implemention of a Cache [Store]
class SqliteCacheStore extends SqliteStore<CacheInfo, CacheEntry> {
  /// Builds a [SqliteCacheStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  SqliteCacheStore(super.adapter, {super.codec});
}
