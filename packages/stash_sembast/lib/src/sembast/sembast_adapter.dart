import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast_web/sembast_web.dart';

/// The [CacheStoreAdapter] provides a bridge between the store and the
/// backend
abstract class CacheStoreAdapter {
  /// Deletes a named cache from a store or the store itself if a named cache is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name);

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named caches in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll();
}

/// The [SembastAdapter] provides a bridge between the store and the
/// Hive backend
abstract class SembastAdapter extends CacheStoreAdapter {
  final int? version;
  final OnVersionChangedFunction? onVersionChanged;
  final DatabaseMode? mode;
  final SembastCodec? codec;

  /// The Sembast database object
  Database? _db;

  /// List of stores per cache name
  final Map<String, StoreRef<String, Map<String, dynamic>>> _cacheStore = {};

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
    if (_cacheStore.containsKey(name)) {
      return _cacheStore[name]!;
    }

    final cacheStore =
        _cacheStore[name] = StoreRef<String, Map<String, dynamic>>(name);

    return cacheStore;
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

  @override
  Future<void> delete(String name) {
    return _database().then((db) {
      return _store(name).delete(db);
    });
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheStore.keys.map((name) {
      return _database().then((db) {
        return db
            .close()
            .then((_) => databaseFactoryIo.deleteDatabase(db.path))
            .then((_) => _cacheStore.remove(name));
      });
    }));
  }
}

class SembastFileAdapter extends SembastAdapter {
  /// The location of the database file
  final File file;

  /// Builds a [SembastFileAdapter].
  ///
  /// * [file]: The location of the database file
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastFileAdapter(this.file,
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
    return databaseFactoryIo.openDatabase(file.path,
        version: version,
        onVersionChanged: onVersionChanged,
        mode: mode,
        codec: codec);
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
}

class SembastWebAdapter extends SembastAdapter {
  final String name;

  /// Builds a [SembastWebAdapter].
  ///
  /// * [name]: The name of the database
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastWebAdapter(this.name,
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
    return databaseFactoryWeb.openDatabase(name,
        version: version,
        onVersionChanged: onVersionChanged,
        mode: mode,
        codec: codec);
  }
}
