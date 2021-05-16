import 'package:moor/moor.dart';
import 'package:stash/stash.dart';
import 'package:stash_sqlite/src/sqlite/cache_database.dart';
import 'package:stash_sqlite/src/sqlite/table/cache_table.dart';
import 'package:stash_sqlite/src/sqlite/table/iso8601_converter.dart';

part 'cache_dao.g.dart';

@UseDao(tables: [CacheTable])

/// Dao that encapsulates operations over the database
class CacheDao extends DatabaseAccessor<CacheDatabase> with _$CacheDaoMixin {
  /// Builds a [CacheDao]
  ///
  /// * [db]: The [CacheDatabase]
  CacheDao(CacheDatabase db) : super(db);

  /// Counts the number of entries on a named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the number of entries on the named cache
  Future<int> count(String name) {
    final countColumn = cacheTable.key.count();
    final query = selectOnly(cacheTable)
      ..addColumns([countColumn])
      ..where(cacheTable.name.equals(name));

    return query.map((row) => row.read(countColumn)).getSingle();
  }

  /// Returns all the keys on a named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns all the keys on the named cache
  Future<List<String>> keys(String name) {
    final keyColumn = cacheTable.key;
    final query = selectOnly(cacheTable)
      ..addColumns([keyColumn])
      ..where(cacheTable.name.equals(name));

    return query
        .map((row) => row.read(keyColumn))
        .get()
        .then((keys) => keys.map((key) => key!).toList());
  }

  /// Builds and returns the query that retrieves header information from the cache
  JoinedSelectStatement<$CacheTableTable, CacheData> _statQuery() {
    return selectOnly(cacheTable)
      ..addColumns([
        cacheTable.key,
        cacheTable.expiryTime,
        cacheTable.creationTime,
        cacheTable.accessTime,
        cacheTable.updateTime,
        cacheTable.hitCount
      ]);
  }

  /// Converts from a [TypedResult] row to a [CacheStat]
  ///
  /// * [row]: The [TypedResult] row
  ///
  /// Returns the [CacheStat] after conversion
  CacheStat _statMapper(TypedResult row) {
    var converter = const Iso8601Converter();

    final key = row.read(cacheTable.key);
    var expiryTime = converter.mapToDart(row.read(cacheTable.expiryTime));
    var creationTime = converter.mapToDart(row.read(cacheTable.creationTime));
    var accessTime = converter.mapToDart(row.read(cacheTable.accessTime));
    var updateTime = converter.mapToDart(row.read(cacheTable.updateTime));
    var hitCount = row.read(cacheTable.hitCount);

    return CacheStat(key!, expiryTime!, creationTime!,
        accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
  }

  /// Returns the list of all cache headers on a named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns a [Iterable] over all [CacheStat]s
  Future<Iterable<CacheStat>> stats(String name) {
    var query = _statQuery()..where(cacheTable.name.equals(name));

    return query.map(_statMapper).get();
  }

  /// Converts a [CacheData] to a [CacheEntry]
  ///
  /// * [data]: The [CacheData]
  /// * [valueDecoder]: The function used to convert a list of bytes to the cache value
  ///
  /// Returns the [CacheEntry] after conversion
  CacheEntry? _toCacheEntry(
      CacheData? data, dynamic Function(Uint8List) valueDecoder) {
    return data != null
        ? CacheEntry(data.key, valueDecoder(data.value), data.expiryTime,
            data.creationTime,
            accessTime: data.accessTime,
            updateTime: data.updateTime,
            hitCount: data.hitCount)
        : null;
  }

  /// Returns the list of all cache entries on a named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns a [Iterable] over all [CacheEntry]s
  Future<Iterable<CacheEntry>> entries(
      String cacheName, dynamic Function(Uint8List) valueDecoder) {
    return (select(cacheTable)..where((entry) => entry.name.equals(cacheName)))
        .get()
        .then((entries) =>
            entries.map((entry) => _toCacheEntry(entry, valueDecoder)!));
  }

  /// Checks if a key exists on a named cache
  ///
  /// * [name]: The name of the cache
  /// * [key]: The key to check on the named cache
  ///
  /// Returns true if the named cached contains the provided key, false otherwise
  Future<bool> containsKey(String name, String key) {
    return (select(cacheTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .getSingleOrNull()
        .then((value) => value != null);
  }

  /// Returns a cache header for a key on named cache
  ///
  /// * [name]: The name of the cache
  /// * [key]: The key on the cache
  ///
  /// Returns the named cache key [CacheStat]
  Future<CacheStat> getStat(String name, String key) {
    var query = _statQuery()
      ..where(cacheTable.name.equals(name) & cacheTable.key.equals(key));

    return query.map(_statMapper).getSingle();
  }

  /// Returns the list of all cache headers on a named cache, filtered by the provided keys
  ///
  /// * [name]: The name of the cache
  /// * [keys]: The list of keys
  ///
  /// Returns a [Iterable] over all [CacheStat]s retrieved
  Future<Iterable<CacheStat>> getStats(String name, Iterable<String> keys) {
    var query = _statQuery()
      ..where(cacheTable.name.equals(name) & cacheTable.key.isIn(keys));

    return query.map(_statMapper).get();
  }

  /// Updates the header of a named cache
  ///
  /// * [name]: The name of the cache
  /// * [stat]: The [CacheStat]
  ///
  /// Returns the number of updated enties
  Future<int> updateStat(String name, CacheStat stat) {
    return (update(cacheTable)
          ..where(
              (entry) => entry.name.equals(name) & entry.key.equals(stat.key)))
        .write(CacheTableCompanion(
            expiryTime: Value(stat.expiryTime),
            creationTime: Value(stat.creationTime),
            accessTime: Value(stat.accessTime),
            updateTime: Value(stat.updateTime),
            hitCount: Value(stat.hitCount)));
  }

  /// Returns a cache entry for a key on named cache
  ///
  /// * [name]: The name of the cache
  /// * [key]: The key on the cache
  /// * [valueDecoder]: The function used to convert a list of bytes to the cache value
  ///
  /// Returns the named cache key [CacheEntry]
  Future<CacheEntry?> getEntry(
      String name, String key, dynamic Function(Uint8List) valueDecoder) {
    return (select(cacheTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .getSingleOrNull()
        .then((entry) => _toCacheEntry(entry, valueDecoder));
  }

  /// Creates a [CacheData] for a named cache entry
  ///
  /// * [name]: The name of the cache
  /// * [entry]: The cache entry
  /// * [valueEncoder]: The function used to serialize a object to a list of bytes
  ///
  /// Return a [CacheData] for storage
  CacheData _toCacheData(
      String name, CacheEntry entry, Uint8List Function(dynamic) valueEncoder) {
    return CacheData(
        name: name,
        key: entry.key,
        expiryTime: entry.expiryTime,
        creationTime: entry.creationTime,
        accessTime: entry.accessTime,
        updateTime: entry.updateTime,
        hitCount: entry.hitCount,
        extra: null,
        value: valueEncoder(entry.value));
  }

  /// Adds a [CacheEntry] to the named cache
  ///
  /// * [name]: The name of the cache
  /// * [entry]: The cache entry
  /// * [valueEncoder]: The function used to serialize a object to a list of bytes
  Future<void> putEntry(
      String name, CacheEntry entry, Uint8List Function(dynamic) valueEncoder) {
    return into(cacheTable).insert(_toCacheData(name, entry, valueEncoder),
        mode: InsertMode.insertOrReplace);
  }

  /// Removes a entry from a named cache
  ///
  /// * [name]: The name of the cache
  /// * [key]: The cache key
  ///
  /// Returns the number of records updated
  Future<int> remove(String name, String key) {
    return (delete(cacheTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .go();
  }

  /// Clears a named cache
  ///
  /// * [name]: The name of the cache
  ///
  /// Return the number of records updated
  Future<int> clear(String name) {
    return (delete(cacheTable)..where((entry) => entry.name.equals(name))).go();
  }

  /// Deletes all caches
  ///
  /// Return the number of records updated
  Future<int> clearAll() {
    return delete(cacheTable).go();
  }
}
