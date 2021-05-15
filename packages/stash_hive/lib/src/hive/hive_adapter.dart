import 'package:hive/hive.dart';

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

/// The [HiveAdapter] provides a bridge between the store and the
/// Hive backend
abstract class HiveAdapter<T extends BoxBase<Map>> extends CacheStoreAdapter {
  /// The path to the box
  final String? path;

  /// The encryption cypher
  final HiveCipher? encryptionCipher;

  /// If it supports crash recovery
  final bool? crashRecovery;

  /// List of boxes per cache name
  final Map<String, T> _cacheStore = {};

  /// Builds a [HiveStoreAdapter].
  ///
  /// * [path]: The base location of the Hive storage
  HiveAdapter({this.path, this.encryptionCipher, this.crashRecovery});

  /// Opens the box
  ///
  /// * [name]: The name of the cache
  Future<T> openBox(String name);

  /// Returns the box value by key
  ///
  /// * [store]: The Hive box
  /// * [key]: The cache key
  ///
  /// Returns the [Map] stored in the box
  Future<Map?> boxValue(T store, String key);

  Future<T> store(String name) {
    if (_cacheStore.containsKey(name)) {
      return Future.value(_cacheStore[name]);
    }

    return openBox(name).then((store) {
      _cacheStore[name] = store;

      return store;
    });
  }

  @override
  Future<void> delete(String name) {
    if (_cacheStore.containsKey(name)) {
      return Hive.deleteBoxFromDisk(name).then((_) => _cacheStore.remove(name));
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    return Future.wait(_cacheStore.keys.map((name) {
      return Hive.deleteBoxFromDisk(name).then((_) => _cacheStore.remove(name));
    }));
  }
}

class DefaultHiveAdapter extends HiveAdapter<Box<Map>> {
  DefaultHiveAdapter(
      {String? path, HiveCipher? encryptionCipher, bool? crashRecovery})
      : super(
            path: path,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery);

  @override
  Future<Box<Map>> openBox(String name) {
    return Future.value(Hive.openBox(name,
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery ?? false));
  }

  @override
  Future<Map?> boxValue(Box<Map> store, String key) {
    return Future.value(store.get(key));
  }
}

class LazyHiveAdapter extends HiveAdapter<LazyBox<Map>> {
  LazyHiveAdapter(
      {String? path, HiveCipher? encryptionCipher, bool? crashRecovery})
      : super(
            path: path,
            encryptionCipher: encryptionCipher,
            crashRecovery: crashRecovery);

  @override
  Future<LazyBox<Map>> openBox(String name) {
    return Hive.openLazyBox(name,
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery ?? false);
  }

  @override
  Future<Map?> boxValue(LazyBox<Map> store, String key) {
    return store.get(key);
  }
}
