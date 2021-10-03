import 'dart:typed_data';

import 'package:stash/stash_api.dart';
import 'package:stash/stash_msgpack.dart';

import 'sqlite_adapter.dart';

/// Sqlite based implemention of a [Store]
class SqliteStore<S extends Stat, E extends Entry<S>> implements Store<S, E> {
  /// The adapter
  final SqliteAdapter<S, E> _adapter;

  /// The cache codec to use
  final StoreCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [SqliteStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SqliteStore(this._adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _codec = codec ?? MsgpackCodec(),
        _fromEncodable = fromEncodable;

  @override
  Future<int> size(String name) => _adapter.dao.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _adapter.dao.keys(name);

  @override
  Future<Iterable<S>> stats(String name) => _adapter.dao.stats(name);

  /// Returns a value decoded from the provided list of bytes
  ///
  /// * [bytes]: The list of bytes
  ///
  /// Returns the decoded value from the list of bytes
  dynamic _valueDecoder(Uint8List bytes) {
    var reader = _codec.decoder(bytes, fromEncodable: _fromEncodable);

    return reader.read();
  }

  @override
  Future<Iterable<E>> values(String name) =>
      _adapter.dao.entries(name, _valueDecoder);

  @override
  Future<bool> containsKey(String name, String key) {
    return _adapter.dao.containsKey(name, key);
  }

  @override
  Future<S> getStat(String name, String key) {
    return _adapter.dao.getStat(name, key);
  }

  @override
  Future<Iterable<S>> getStats(String name, Iterable<String> keys) {
    return _adapter.dao.getStats(name, keys);
  }

  @override
  Future<void> setStat(String name, String key, S stat) {
    return _adapter.dao.updateStat(name, stat);
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _adapter.dao.getEntry(name, key, _valueDecoder);
  }

  /// Encodes a value into a list of bytes
  ///
  /// * [value]: The value to encode
  ///
  /// Returns the value encoded as a list of bytes
  Uint8List _valueEncoder(dynamic value) {
    var writer = _codec.encoder();

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
class SqliteVaultStore extends SqliteStore<VaultStat, VaultEntry> {
  /// Builds a [SqliteVaultStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SqliteVaultStore(SqliteAdapter<VaultStat, VaultEntry> adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, codec: codec, fromEncodable: fromEncodable);
}

/// Sqlite based implemention of a Cache [Store]
class SqliteCacheStore extends SqliteStore<CacheStat, CacheEntry> {
  /// Builds a [SqliteCacheStore].
  ///
  /// * [_adapter]: The [SqliteAdapter]
  /// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SqliteCacheStore(SqliteAdapter<CacheStat, CacheEntry> adapter,
      {StoreCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(adapter, codec: codec, fromEncodable: fromEncodable);
}
