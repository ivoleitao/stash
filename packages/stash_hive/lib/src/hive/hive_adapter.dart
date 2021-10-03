import 'package:hive/hive.dart';
import 'package:universal_platform/universal_platform.dart';

/// The [StoreAdapter] provides a bridge between the store and the
/// backend
abstract class StoreAdapter {}

/// The [HiveAdapter] provides a bridge between the store and the
/// Hive backend
abstract class HiveAdapter<T extends BoxBase<Map>> extends StoreAdapter {
  /// The path to the box
  final String? path;

  /// The encryption cypher
  final HiveCipher? encryptionCipher;

  /// If it supports crash recovery
  final bool? crashRecovery;

  /// List of vault/caches
  final Map<String, T> _store = {};

  /// Builds a [HiveAdapter].
  ///
  /// * [path]: The base location of the Hive storage
  HiveAdapter({this.path, this.encryptionCipher, this.crashRecovery});

  /// Opens the box
  ///
  /// * [name]: The name of the vault/cache
  Future<T> openBox(String name);

  /// Returns the box value by key
  ///
  /// * [store]: The Hive box
  /// * [key]: The store key
  ///
  /// Returns the [Map] stored in the box
  Future<Map?> boxValue(T store, String key);

  Future<T> store(String name) {
    if (_store.containsKey(name)) {
      return Future.value(_store[name]);
    }

    return openBox(name).then((store) {
      _store[name] = store;

      return store;
    });
  }

  Future<void> _delete(String name) {
    if (UniversalPlatform.isWeb) {
      // https://github.com/hivedb/hive/issues/344
      return _store[name]!.clear().then((_) => _store.remove(name));
    } else {
      return Hive.deleteBoxFromDisk(name).then((_) => _store.remove(name));
    }
  }

  /// Deletes a vault/cache from a store or the store itself
  ///
  /// * [name]: The vault/cache name
  Future<void> delete(String name) {
    if (_store.containsKey(name)) {
      return _delete(name);
    }

    return Future.value();
  }

  /// Deletes the store a if a store is implemented in a way that puts all the
  /// named vault/cache in one storage, or stores(s) if multiple storages are used
  Future<void> deleteAll() {
    return Future.wait(_store.keys.map((name) {
      return _delete(name);
    }));
  }
}

class HiveDefaultAdapter extends HiveAdapter<Box<Map>> {
  HiveDefaultAdapter(
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

class HiveLazyAdapter extends HiveAdapter<LazyBox<Map>> {
  HiveLazyAdapter(String path,
      {HiveCipher? encryptionCipher, bool? crashRecovery})
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
