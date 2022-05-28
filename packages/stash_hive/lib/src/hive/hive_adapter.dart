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

  /// List of boxs
  final Map<String, T> _boxes = {};

  /// Builds a [HiveAdapter].
  ///
  /// * [path]: The base location of the Hive storage
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  HiveAdapter({this.path, this.encryptionCipher, this.crashRecovery});

  /// Creates a box
  ///
  /// * [name]: The box name
  Future<void> create(String name) {
    if (!_boxes.containsKey(name)) {
      return openBox(name).then((box) {
        _boxes[name] = box;
      });
    }

    return Future.value();
  }

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

  /// Returns a specific box identified by [name]
  ///
  /// * [name]: The box name
  T? box(String name) {
    return _boxes[name];
  }

  /// Deletes a box
  ///
  /// [name]: The box name
  Future<void> _deletebox(String name) {
    if (_boxes.containsKey(name)) {
      if (UniversalPlatform.isWeb) {
        // https://github.com/hivedb/hive/issues/344
        return _boxes[name]!.clear().then((_) => _boxes.remove(name));
      } else {
        return Hive.deleteBoxFromDisk(name).then((_) => _boxes.remove(name));
      }
    }

    return Future.value();
  }

  /// Deletes a box from a store
  ///
  /// * [name]: The store name
  Future<void> delete(String name) {
    return _deletebox(name);
  }

  /// Deletes all the boxes
  Future<void> deleteAll() {
    return Future.wait(_boxes.keys.map((name) {
      return _deletebox(name);
    }));
  }
}

class HiveDefaultAdapter extends HiveAdapter<Box<Map>> {
  HiveDefaultAdapter({super.path, super.encryptionCipher, super.crashRecovery});

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
  HiveLazyAdapter({super.path, super.encryptionCipher, super.crashRecovery});

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
