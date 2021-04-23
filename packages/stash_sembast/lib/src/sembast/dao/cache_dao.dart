import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Dao that encapsulates operations over the database
class CacheDao {
  /// The Sembast database object
  final Database _db;

  /// The Sembast store
  final StoreRef<String, Map<String, dynamic>> _store;

  /// Builds a [CacheDao]
  ///
  /// * [_db]: The Sembast database object
  /// * [_store]: The Sembast store
  CacheDao(this._db, this._store);

  /// Checks if a entry exists
  ///
  /// * [key]: The cache key
  ///
  /// Returns true if the cache contains a entry with the provided key
  Future<bool> exists(String key) {
    return _store.record(key).exists(_db);
  }

  /// Counts the number of entries using a optionally provided [Filter]
  ///
  /// * [filter]: The [Filter]
  ///
  /// Returns the number of entries
  Future<int> count({Filter? filter}) {
    return _store.count(_db, filter: filter);
  }

  /// Returns all the keys using a optionally provided [Finder]
  ///
  /// * [finder]: The [Finder]
  ///
  /// Returns the number of entries
  Future<List<String>> keys({Finder? finder}) {
    return _store.findKeys(_db, finder: finder);
  }

  /// Returns the json map associated with the provided key
  ///
  /// * [key]: The cache key
  ///
  /// Returns the key json map
  Future<Map<String, dynamic>?> getByKey(String key) {
    return _store.record(key).get(_db);
  }

  /// Returns the json maps of the provided keys
  ///
  /// * [keys]: The list of cache keys
  ///
  /// Returns the key json map
  Future<List<Map<String, dynamic>?>> getByKeys(Iterable<String> keys) {
    return _store.records(keys).get(_db);
  }

  /// Finds the list of all [RecordSnapshot]'s according with the provided
  /// [Finder]
  ///
  /// * [finder]: The [Finder]
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> find(
      {Finder? finder}) {
    return _store.find(_db, finder: finder);
  }

  /// Adds a value to the store
  ///
  /// * [key]: The cache key
  /// * [value]: The value to set
  /// * [merge]: If the value should be merged
  ///
  /// Returns the updated value
  Future<Map<String, dynamic>> put(String key, Map<String, dynamic> value,
      {bool? merge}) {
    return _store.record(key).put(_db, value, merge: merge);
  }

  /// Removes a entry by key
  ///
  /// * [key]: The cache key
  ///
  /// Returns the dynamic record
  Future<dynamic> remove(String key) {
    return _store.record(key).delete(_db);
  }

  /// Clears the cache
  ///
  /// Return the number of records updated
  Future<int> clear() {
    return _store.delete(_db);
  }

  /// Deletes the database
  Future<void> deleteDatabase() {
    return _db.close().then((_) => databaseFactoryIo.deleteDatabase(_db.path));
  }
}
