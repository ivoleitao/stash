import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

/// The [SembastAdapter] provides a bridge between the store and the
/// Sembast backend
abstract class SembastAdapter {
  /// The Sembast database object
  final Database _db;

  /// List of partitions per name
  final Map<String, StoreRef<String, Map<String, dynamic>>> _partitions = {};

  /// [SembastAdapter] constructor
  ///
  /// * [_db]: The database
  SembastAdapter(this._db);

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      _partitions[name] = StoreRef<String, Map<String, dynamic>>(name);
    }

    return Future.value();
  }

  /// Returns the [StoreRef]
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the store [StoreRef]
  StoreRef<String, Map<String, dynamic>>? _partition(String name) {
    return _partitions[name];
  }

  /// Checks if a entry exists
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns true if contains a entry with the provided key
  Future<bool> exists(String name, String key) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.record(key).exists(_db);
    }

    return Future.value(false);
  }

  /// Counts the number of entries using a optionally provided [Filter]
  ///
  /// * [name]: The partition name
  /// * [filter]: The [Filter]
  ///
  /// Returns the number of entries
  Future<int> count(String name, {Filter? filter}) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.count(_db, filter: filter);
    }

    return Future.value(0);
  }

  /// Returns all the keys using a optionally provided [Finder]
  ///
  /// * [name]: The partition name
  /// * [finder]: The [Finder]
  ///
  /// Returns the number of entries
  Future<List<String>> keys(String name, {Finder? finder}) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.findKeys(_db, finder: finder);
    }

    return Future.value(const <String>[]);
  }

  /// Returns the json map associated with the provided key
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  ///
  /// Returns the key json map
  Future<Map<String, dynamic>?> getByKey(String name, String key) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.record(key).get(_db);
    }

    return Future.value();
  }

  /// Returns the json maps of the provided keys
  ///
  /// * [name]: The partition name
  /// * [keys]: The list of cache keys
  ///
  /// Returns the key json map
  Future<List<Map<String, dynamic>?>> getByKeys(
      String name, Iterable<String> keys) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.records(keys).get(_db);
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
    final partition = _partition(name);

    if (partition != null) {
      return partition.find(_db, finder: finder);
    }

    return Future.value(const <RecordSnapshot<String, Map<String, dynamic>>>[]);
  }

  /// Adds a value to the partition
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  /// * [value]: The value to set
  /// * [merge]: If the value should be merged
  ///
  /// Returns the updated value
  Future<void> put(String name, String key, Map<String, dynamic> value,
      {bool? merge}) {
    final partition = _partition(name);

    if (partition != null) {
      return partition
          .record(key)
          .put(_db, value, merge: merge)
          .then((value) => null);
    }

    return Future.value();
  }

  /// Removes a entry by key
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<void> remove(String name, String key) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.record(key).delete(_db);
    }

    return Future.value();
  }

  /// Clears a partition
  ///
  /// * [name]: The partition name
  Future<void> clear(String name) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.delete(_db).then((value) => null);
    }

    return Future.value();
  }

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> _deletePartition(String name) {
    final partition = _partition(name);

    if (partition != null) {
      return partition.delete(_db);
    }

    return Future.value();
  }

  /// Deletes a named cache from a store or the store itself if a named cache is
  /// stored individually
  ///
  /// * [name]: The cache name
  Future<void> delete(String name) {
    return _deletePartition(name);
  }

  Future<void> deleteDatabase(String path);

  /// Deletes the store if a store is implemented in a way that puts all the
  /// named stashes in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_partitions.keys.map((name) {
      return _db
          .close()
          .then((_) => deleteDatabase(_db.path))
          .then((_) => _partitions.remove(name));
    }));
  }
}

class SembastLocalAdapter extends SembastAdapter {
  /// The location of the database file
  final String path;

  /// [SembastLocalAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [path]: The location of the database file
  SembastLocalAdapter._(super.db, this.path);

  /// Builds [SembastLocalAdapter].
  ///
  /// * [path]: The location of the database file
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  static Future<SembastAdapter> build(String path,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec}) {
    return databaseFactoryIo
        .openDatabase(path,
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec)
        .then((db) => SembastLocalAdapter._(db, path));
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryIo.deleteDatabase(path);
  }
}

class SembastMemoryAdapter extends SembastAdapter {
  /// The database name
  final String name;

  /// [SembastMemoryAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [name]: The name of the database
  SembastMemoryAdapter._(super.db, this.name);

  /// Builds [SembastMemoryAdapter].
  ///
  /// * [name]: The name of the database
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  static Future<SembastAdapter> build(String name,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec}) {
    return newDatabaseFactoryMemory()
        .openDatabase(name,
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec)
        .then((db) => SembastMemoryAdapter._(db, name));
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryMemory.deleteDatabase(path);
  }
}
