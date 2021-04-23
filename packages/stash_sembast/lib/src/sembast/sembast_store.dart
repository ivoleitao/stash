import 'package:path/path.dart' as p;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_extensions.dart';

import 'dao/cache_dao.dart';

/// Sembast based implemention of a [CacheStore]
class SembastStore extends CacheStore {
  /// The base location of the Sembast storage
  final String _path;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// The Sembast database object
  Database? _db;

  /// List of Sembast stores per cache name
  final Map<String, StoreRef<String, Map<String, dynamic>>> _cacheStoreMap = {};

  /// Builds a [SembastStore].
  ///
  /// * [_path]: The base location of the Sembast storage
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SembastStore(this._path,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  /// Returns the [CacheDao] that provides access to the stored objects.
  /// If the database is closed it's opened on the first request
  ///
  /// * [name]: The name of the cache
  ///
  /// Returns the [CacheDao]
  Future<CacheDao> _cacheStore(String name) {
    Future<Database> getDB;
    if (_db == null) {
      getDB = databaseFactoryIo.openDatabase(p.join(_path, name)).then((d) {
        _db = d;

        return d;
      });
    } else {
      getDB = Future.value(_db);
    }

    return getDB.then((db) {
      if (_cacheStoreMap.containsKey(name)) {
        return CacheDao(db, _cacheStoreMap[name]!);
      }

      final cacheStore =
          _cacheStoreMap[name] = StoreRef<String, Map<String, dynamic>>(name);

      return CacheDao(db, cacheStore);
    });
  }

  @override
  Future<int> size(String name) => _cacheStore(name).then((dao) => dao.count());

  @override
  Future<Iterable<String>> keys(String name) =>
      _cacheStore(name).then((dao) => dao.keys());

  /// Retrieves a [CacheEntry] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [CacheEntry]
  CacheEntry? _getEntryFromValue(Map<String, dynamic>? value) {
    return value != null
        ? SembastExtensions.fromJson(value, fromJson: _fromEncodable)
        : null;
  }

  /// Retrieves a [CacheStat] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [CacheStat]
  CacheStat? _getStatFromValue(Map<String, dynamic> value) {
    return _getEntryFromValue(value)?.stat;
  }

  /// Calls the [CacheDao] and retries a [CacheEntry] by key
  ///
  /// * [dao]: The [CacheDao]
  /// * [key]: The cache key
  ///
  ///  Returns the corresponding [CacheEntry]
  Future<CacheEntry?> _getEntryFromStore(CacheDao dao, String key) =>
      dao.getByKey(key).then(_getEntryFromValue);

  /// Returns the [CacheEntry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntry(String name, String key) {
    return _cacheStore(name).then((dao) => _getEntryFromStore(dao, key));
  }

  /// Gets the list of all the records by cache name
  ///
  /// * [name]: The name of the cache
  ///
  ///  Returns the list of [RecordSnapshot]'s by cache name
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> _getRecords(
      String name) {
    return _cacheStore(name).then((dao) => dao.find());
  }

  @override
  Future<Iterable<CacheStat>> stats(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getStatFromValue(record.value))
          .map((stat) => stat!)
          .toList());

  @override
  Future<Iterable<CacheEntry>> values(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getEntryFromValue(record.value))
          .map((entry) => entry!)
          .toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      _cacheStore(name).then((dao) => dao.exists(key));

  @override
  Future<CacheStat?> getStat(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.stat);
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) {
    return _cacheStore(name).then((dao) => dao.getByKeys(keys)).then(
        (records) =>
            records.map((record) => _getEntryFromValue(record)).toList());
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _cacheStore(name).then((dao) {
      return _getEntryFromStore(dao, key)
          .then((entry) => dao.put(key, (entry!..stat = stat).toSembastJson()));
    });
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    return _cacheStore(name).then((dao) => dao.put(key, entry.toSembastJson()));
  }

  @override
  Future<void> remove(String name, String key) {
    return _cacheStore(name).then((ctx) => ctx.remove(key));
  }

  @override
  Future<void> clear(String name) {
    return _cacheStore(name).then((ctx) => ctx.clear());
  }

  @override
  Future<void> delete(String name) {
    if (_cacheStoreMap.containsKey(name)) {
      return _cacheStore(name).then((ctx) {
        return ctx.clear().then((_) => _cacheStoreMap.remove(name));
      });
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheStoreMap.keys.map((name) {
      return _cacheStore(name).then((ctx) {
        return ctx.deleteDatabase().then((_) => _cacheStoreMap.remove(name));
      });
    }));
  }
}
