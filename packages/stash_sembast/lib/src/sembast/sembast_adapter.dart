import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

/// The [SembastAdapter] provides a bridge between the store and the
/// Sembast backend
abstract class SembastAdapter {
  final int? version;
  final OnVersionChangedFunction? onVersionChanged;
  final DatabaseMode? mode;
  final SembastCodec? codec;

  /// The Sembast database object
  Database? _db;

  /// List of stores per name
  final Map<String, StoreRef<String, Map<String, dynamic>>> _stores = {};

  /// Builds a [SembastAdapter].
  ///
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastAdapter({this.version, this.onVersionChanged, this.mode, this.codec});

  /// Opens a Sembast database
  Future<Database> openDatabase();

  /// Creates a store
  ///
  /// * [name]: The store name
  Future<void> create(String name) {
    Future<Database> database() {
      if (_db == null) {
        return openDatabase().then((db) => _db = db);
      }

      return Future.value(_db);
    }

    if (!_stores.containsKey(name)) {
      return database().then((db) {
        _stores[name] = StoreRef<String, Map<String, dynamic>>(name);

        return null;
      });
    }

    return Future.value();
  }

  /// Returns the [StoreRef]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the store [StoreRef]
  StoreRef<String, Map<String, dynamic>>? _store(String name) {
    return _stores[name];
  }

  /// Checks if a entry exists
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  /// Returns true if contains a entry with the provided key
  Future<bool> exists(String name, String key) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.record(key).exists(db);
    }

    return Future.value(false);
  }

  /// Counts the number of entries using a optionally provided [Filter]
  ///
  /// * [name]: The store name
  /// * [filter]: The [Filter]
  ///
  /// Returns the number of entries
  Future<int> count(String name, {Filter? filter}) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.count(db, filter: filter);
    }

    return Future.value(0);
  }

  /// Returns all the keys using a optionally provided [Finder]
  ///
  /// * [name]: The cache name
  /// * [finder]: The [Finder]
  ///
  /// Returns the number of entries
  Future<List<String>> keys(String name, {Finder? finder}) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.findKeys(db, finder: finder);
    }

    return Future.value(const <String>[]);
  }

  /// Returns the json map associated with the provided key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  ///
  /// Returns the key json map
  Future<Map<String, dynamic>?> getByKey(String name, String key) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.record(key).get(db);
    }

    return Future.value();
  }

  /// Returns the json maps of the provided keys
  ///
  /// * [name]: The cache name
  /// * [keys]: The list of cache keys
  ///
  /// Returns the key json map
  Future<List<Map<String, dynamic>?>> getByKeys(
      String name, Iterable<String> keys) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.records(keys).get(db);
    }

    return Future.value(const <Map<String, dynamic>?>[]);
  }

  /// Finds the list of all [RecordSnapshot]'s according with the provided
  /// [Finder]
  ///
  /// * [name]: The store name
  /// * [finder]: The [Finder]
  ///
  /// Returns the list of records
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> find(String name,
      {Finder? finder}) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.find(db, finder: finder);
    }

    return Future.value(const <RecordSnapshot<String, Map<String, dynamic>>>[]);
  }

  /// Adds a value to the store
  ///
  /// * [name]: The store name
  /// * [key]: The key
  /// * [value]: The value to set
  /// * [merge]: If the value should be merged
  ///
  /// Returns the updated value
  Future<void> put(String name, String key, Map<String, dynamic> value,
      {bool? merge}) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store
          .record(key)
          .put(db, value, merge: merge)
          .then((value) => null);
    }

    return Future.value();
  }

  /// Removes a entry by key
  ///
  /// * [name]: The store name
  /// * [key]: The key
  Future<void> remove(String name, String key) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.record(key).delete(db);
    }

    return Future.value();
  }

  /// Clears the cache
  ///
  /// * [name]: The cache name
  Future<void> clear(String name) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.delete(db).then((value) => null);
    }

    return Future.value();
  }

  Future<void> _deleteStore(String name) {
    final db = _db;
    final store = _store(name);

    if (db != null && store != null) {
      return store.delete(db);
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
      final db = _db;

      if (db != null) {
        return db
            .close()
            .then((_) => deleteDatabase(db.path))
            .then((_) => _stores.remove(name));
      }

      return Future.value();
    }));
  }
}

class SembastLocalAdapter extends SembastAdapter {
  /// The location of the database file
  final String path;

  /// Builds a [SembastLocalAdapter].
  ///
  /// * [path]: The location of the database file
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastLocalAdapter(this.path,
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
