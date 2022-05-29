import 'package:hive/hive.dart';
import 'package:universal_platform/universal_platform.dart';

/// The [HiveAdapter] provides a bridge between the store and the
/// Hive backend
abstract class HiveAdapter<T extends BoxBase<Map>> {
  /// The path to the partition
  final String? path;

  /// The encryption cypher
  final HiveCipher? encryptionCipher;

  /// If it supports crash recovery
  final bool? crashRecovery;

  /// List of boxs
  final Map<String, T> _partitions = {};

  /// [HiveAdapter] constructor
  ///
  /// * [path]: The base location of the Hive box
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  HiveAdapter({this.path, this.encryptionCipher, this.crashRecovery});

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      return openBox(name).then((box) {
        _partitions[name] = box;
      });
    }

    return Future.value();
  }

  /// Opens the box
  ///
  /// * [name]: The name of the partition
  Future<T> openBox(String name);

  /// Returns the box value by key
  ///
  /// * [box]: The Hive box
  /// * [key]: The store key
  ///
  /// Returns the [Map] stored in the box
  Future<Map?> boxValue(T box, String key);

  /// Returns the partition box identified by [name]
  ///
  /// * [name]: The partition name
  T? box(String name) {
    return _partitions[name];
  }

  /// Deletes a partition box
  ///
  /// [name]: The partition name
  Future<void> _deletePartition(String name) {
    if (_partitions.containsKey(name)) {
      if (UniversalPlatform.isWeb) {
        // https://github.com/hivedb/hive/issues/344
        return _partitions[name]!.clear().then((_) => _partitions.remove(name));
      } else {
        return Hive.deleteBoxFromDisk(name)
            .then((_) => _partitions.remove(name));
      }
    }

    return Future.value();
  }

  /// Deletes a partition box
  ///
  /// * [name]: The partition name
  Future<void> delete(String name) {
    return _deletePartition(name);
  }

  /// Deletes all the partition
  Future<void> deleteAll() {
    return Future.wait(_partitions.keys.map((name) {
      return _deletePartition(name);
    }));
  }
}

class HiveDefaultAdapter extends HiveAdapter<Box<Map>> {
  /// [HiveDefaultAdapter] constructor
  ///
  /// * [path]: The base location of the Hive box
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  HiveDefaultAdapter._(
      {super.path, super.encryptionCipher, super.crashRecovery});

  /// Builds a [HiveDefaultAdapter].
  ///
  /// * [path]: The base location of the Hive box
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  static Future<HiveDefaultAdapter> build(
      {String? path, HiveCipher? encryptionCipher, bool? crashRecovery}) {
    return Future.value(HiveDefaultAdapter._(
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery));
  }

  @override
  Future<Box<Map>> openBox(String name) {
    return Future.value(Hive.openBox(name,
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery ?? false));
  }

  @override
  Future<Map?> boxValue(Box<Map> box, String key) {
    return Future.value(box.get(key));
  }
}

class HiveLazyAdapter extends HiveAdapter<LazyBox<Map>> {
  /// [HiveLazyAdapter] constructor
  ///
  /// * [path]: The base location of the Hive box
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  HiveLazyAdapter._({super.path, super.encryptionCipher, super.crashRecovery});

  /// Builds a [HiveLazyAdapter].
  ///
  /// * [path]: The base location of the Hive box
  /// * [encryptionCipher]: The encryption cypher
  /// * [crashRecovery]: If it supports crash recovery
  static Future<HiveLazyAdapter> build(
      {String? path, HiveCipher? encryptionCipher, bool? crashRecovery}) {
    return Future.value(HiveLazyAdapter._(
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery));
  }

  @override
  Future<LazyBox<Map>> openBox(String name) {
    return Hive.openLazyBox(name,
        path: path,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery ?? false);
  }

  @override
  Future<Map?> boxValue(LazyBox<Map> box, String key) {
    return box.get(key);
  }
}
