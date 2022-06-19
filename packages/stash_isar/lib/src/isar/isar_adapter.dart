import 'package:isar/isar.dart';
import 'package:stash_isar/src/isar/vault_model.dart';

import 'cache_model.dart';
import 'entry_model.dart';

/// The [IsarAdapter] provides a bridge between the store and the
/// Isar backend
abstract class IsarAdapter<M extends EntryModel> {
  /// The collection schema
  final CollectionSchema<M> schema;

  /// The path to the partition
  final String? path;

  /// The relaxed durability setting
  final bool? relaxedDurability;

  /// List of partitions
  final Map<String, Isar> _partitions = {};

  /// [IsarAdapter] constructor
  ///
  /// * [schema]: The collection schema
  /// * [path]: The base location of the Isar partition
  /// * [relaxedDurability]: Relaxed durability setting
  IsarAdapter(this.schema, {this.path, this.relaxedDurability});

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      return Isar.open(
              schemas: [schema],
              directory: path,
              name: name,
              relaxedDurability: relaxedDurability ?? true)
          .then((isar) {
        _partitions[name] = isar;

        return Future.value();
      });
    }

    return Future.value();
  }

  /// Returns the partition identified by [name]
  ///
  /// * [name]: The partition name
  Isar? isar(String name) {
    return _partitions[name];
  }

  IsarCollection<M>? partition(String name) {
    return isar(name)?.getCollection<M>();
  }

  /// Deletes a partition
  ///
  /// [name]: The partition name
  Future<void> _deletePartition(String name) {
    final partition = _partitions[name];

    if (partition != null) {
      return partition.close(deleteFromDisk: true);
    }

    return Future.value();
  }

  /// Deletes a partition
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

/// The [IsarVaultAdapter] provides a bridge between the store and the
/// Isar vault backend
class IsarVaultAdapter extends IsarAdapter<VaultModel> {
  /// [IsarVaultAdapter] constructor
  ///
  /// * [path]: The base location of the Isar partition
  /// * [relaxedDurability]: Relaxed durability setting
  IsarVaultAdapter._({super.path, super.relaxedDurability})
      : super(VaultModelSchema);

  /// Builds [IsarVaultAdapter].
  ///
  /// * [path]: The base location of the Isar partition
  /// * [relaxedDurability]: Relaxed durability setting
  static Future<IsarVaultAdapter> build(
      {String? path, bool? relaxedDurability, bool? inspector}) {
    return Future.value(
        IsarVaultAdapter._(path: path, relaxedDurability: relaxedDurability));
  }
}

/// The [IsarCacheAdapter] provides a bridge between the store and the
/// Isar cache backend
class IsarCacheAdapter extends IsarAdapter<CacheModel> {
  /// [IsarCacheAdapter] constructor
  ///
  /// * [path]: The base location of the Isar partition
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [inspector]: Inspector setting
  IsarCacheAdapter._({super.path, super.relaxedDurability})
      : super(CacheModelSchema);

  /// Builds [IsarCacheAdapter].
  ///
  /// * [path]: The base location of the Isar partition
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [inspector]: Inspector setting
  static Future<IsarCacheAdapter> build(
      {String? path, bool? relaxedDurability, bool? inspector}) {
    return Future.value(
        IsarCacheAdapter._(path: path, relaxedDurability: relaxedDurability));
  }
}
