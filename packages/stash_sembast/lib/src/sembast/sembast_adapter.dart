import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

/// The [SembastAdapter] provides a bridge between the store and the
/// Hive backend
abstract class SembastAdapter {
  final int? version;
  final OnVersionChangedFunction? onVersionChanged;
  final DatabaseMode? mode;
  final SembastCodec? codec;

  /// The Sembast database object
  Database? _db;

  /// List of stores per cache name
  final Map<String, StoreRef<String, Map<String, dynamic>>> _stores = {};

  /// Builds a [SembastAdapter].
  ///
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastAdapter({this.version, this.onVersionChanged, this.mode, this.codec});

  Future<Database> openDatabase();

  Future<Database> _database() {
    if (_db == null) {
      return openDatabase().then((db) => _db = db);
    }

    return Future.value(_db);
  }

  StoreRef<String, Map<String, dynamic>> _store(String name) {
    if (_stores.containsKey(name)) {
      return _stores[name]!;
    }

    final store = _stores[name] = StoreRef<String, Map<String, dynamic>>(name);

    return store;
  }

  /// Checks if a entry exists
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns true if the cache contains a entry with the provided key
  Future<bool> exists(String name, String key) {
    return _database().then((db) {
      return _store(name).record(key).exists(db);
    });
  }

  /// Counts the number of entries using a optionally provided [Filter]
  ///
  /// * [name]: The cache name
  /// * [filter]: The [Filter]
  ///
  /// Returns the number of entries
  Future<int> count(String name, {Filter? filter}) {
    return _database().then((db) {
      return _store(name).count(db, filter: filter);
    });
  }

  /// Returns all the keys using a optionally provided [Finder]
  ///
  /// * [name]: The cache name
  /// * [finder]: The [Finder]
  ///
  /// Returns the number of entries
  Future<List<String>> keys(String name, {Finder? finder}) {
    return _database().then((db) {
      return _store(name).findKeys(db, finder: finder);
    });
  }

  /// Returns the json map associated with the provided key
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns the key json map
  Future<Map<String, dynamic>?> getByKey(String name, String key) {
    return _database().then((db) {
      return _store(name).record(key).get(db);
    });
  }

  /// Returns the json maps of the provided keys
  ///
  /// * [name]: The cache name
  /// * [keys]: The list of cache keys
  ///
  /// Returns the key json map
  Future<List<Map<String, dynamic>?>> getByKeys(
      String name, Iterable<String> keys) {
    return _database().then((db) {
      return _store(name).records(keys).get(db);
    });
  }

  /// Finds the list of all [RecordSnapshot]'s according with the provided
  /// [Finder]
  ///
  /// * [name]: The cache name
  /// * [finder]: The [Finder]
  ///
  /// Returns the list of records
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> find(String name,
      {Finder? finder}) {
    return _database().then((db) {
      return _store(name).find(db, finder: finder);
    });
  }

  /// Adds a value to the store
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  /// * [value]: The value to set
  /// * [merge]: If the value should be merged
  ///
  /// Returns the updated value
  Future<Map<String, dynamic>> put(
      String name, String key, Map<String, dynamic> value,
      {bool? merge}) {
    return _database().then((db) {
      return _store(name).record(key).put(db, value, merge: merge);
    });
  }

  /// Removes a entry by key
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns the dynamic record
  Future<dynamic> remove(String name, String key) {
    return _database().then((db) {
      return _store(name).record(key).delete(db);
    });
  }

  /// Clears the cache
  ///
  /// * [name]: The cache name
  ///
  /// Return the number of records updated
  Future<int> clear(String name) {
    return _database().then((db) {
      return _store(name).delete(db);
    });
  }

  Future<void> _deleteStore(String name) {
    if (_stores.containsKey(name)) {
      return _database().then((db) {
        return _store(name).delete(db);
      }).then((_) => null);
    }

    return Future.value();
  }

  /// Deletes a named cache from a store or the store itself if a named cache is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name) {
    return _deleteStore(name);
  }

  Future<void> deleteDatabase(String path);

  /// Deletes the store if a store is implemented in a way that puts all the
  /// named stashes in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_stores.keys.map((name) {
      //return synchronized(() async {
      return _database().then((db) {
        return db
            .close()
            .then((_) => deleteDatabase(db.path))
            .then((_) => _stores.remove(name));
      });
      // });
    }));
  }
}

class SembastPathAdapter extends SembastAdapter {
  /// The location of the database file
  final String path;

  /// Builds a [SembastPathAdapter].
  ///
  /// * [path]: The location of the database file
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastPathAdapter(this.path,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec})
      : super(
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec);

  @override
  Future<Database> openDatabase() {
    return databaseFactoryIo.openDatabase(path,
        version: version,
        onVersionChanged: onVersionChanged,
        mode: mode,
        codec: codec);
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryIo.deleteDatabase(path);
  }
}

class SembastMemoryAdapter extends SembastAdapter {
  /// The database name
  final String name;

  /// Builds a [SembastMemoryAdapter].
  ///
  /// * [name]: The name of the database
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastMemoryAdapter(this.name,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec})
      : super(
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec);

  @override
  Future<Database> openDatabase() {
    return newDatabaseFactoryMemory().openDatabase(name,
        version: version,
        onVersionChanged: onVersionChanged,
        mode: mode,
        codec: codec);
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryMemory.deleteDatabase(path);
  }
}
