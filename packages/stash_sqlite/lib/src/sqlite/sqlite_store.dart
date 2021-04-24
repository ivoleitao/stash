import 'dart:typed_data';

import 'package:stash/stash_api.dart';

import 'cache_database.dart';

/// Sqlite based implemention of a [CacheStore]
class SqliteStore extends CacheStore {
  /// The [CacheDatabase] to use
  final CacheDatabase _db;

  /// The cache codec to use
  final CacheCodec _codec;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [SqliteStore].
  ///
  /// * [_db]: The [CacheDatabase] underpining this store
  /// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to binary representation
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SqliteStore(this._db,
      {CacheCodec? codec,
      dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _codec = codec ?? MsgpackCodec(),
        _fromEncodable = fromEncodable;

  @override
  Future<int> size(String name) => _db.cacheDao.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _db.cacheDao.keys(name);

  @override
  Future<Iterable<CacheStat>> stats(String name) => _db.cacheDao.stats(name);

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
  Future<Iterable<CacheEntry>> values(String name) =>
      _db.cacheDao.entries(name, _valueDecoder);

  @override
  Future<bool> containsKey(String name, String key) {
    return _db.cacheDao.containsKey(name, key);
  }

  @override
  Future<CacheStat> getStat(String name, String key) {
    return _db.cacheDao.getStat(name, key);
  }

  @override
  Future<Iterable<CacheStat>> getStats(String name, Iterable<String> keys) {
    return _db.cacheDao.getStats(name, keys);
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _db.cacheDao.updateStat(name, stat);
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _db.cacheDao.getEntry(name, key, _valueDecoder);
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
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    return _db.cacheDao.putEntry(name, entry, _valueEncoder);
  }

  @override
  Future<void> remove(String name, String key) {
    return _db.cacheDao.remove(name, key);
  }

  @override
  Future<void> clear(String name) {
    return _db.cacheDao.clear(name);
  }

  @override
  Future<void> delete(String name) {
    return _db.cacheDao.clear(name);
  }

  @override
  Future<void> deleteAll() {
    return _db.cacheDao.clearAll();
  }
}
