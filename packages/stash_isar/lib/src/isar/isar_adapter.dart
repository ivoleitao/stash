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
  final String path;

  /// The relaxed durability setting
  final bool? relaxedDurability;

  /// The max size in MB
  final int? maxSizeMib;

  /// The condition for the db to be compacted on launch
  final CompactCondition? compactOnLaunch;

  /// If the inspector is enabled
  final bool? inspector;

  /// List of partitions
  final Map<String, Isar> _partitions = {};

  /// [IsarAdapter] constructor
  ///
  /// * [schema]: The collection schema
  /// * [path]: The base location of the Isar partition
  /// * [maxSizeMib]: The max size Mib
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [compactOnLaunch]: The condition for the db to be compacted on launch
  /// * [inspector]: If the inspector is enabled
  IsarAdapter(this.schema, this.path,
      {this.maxSizeMib = Isar.defaultMaxSizeMiB,
      this.relaxedDurability,
      this.compactOnLaunch,
      this.inspector = true});

  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name) {
    if (!_partitions.containsKey(name)) {
      return Isar.open([schema],
              directory: path,
              name: name,
              maxSizeMiB: maxSizeMib ?? Isar.defaultMaxSizeMiB,
              relaxedDurability: relaxedDurability ?? true,
              compactOnLaunch: compactOnLaunch,
              inspector: inspector ?? true)
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
  Isar? _isar(String name) {
    return _partitions[name];
  }

  IsarCollection<M>? partition(String name) {
    return _isar(name)?.collection<M>();
  }

  /// Deletes a partition
  ///
  /// [name]: The partition name
  Future<void> _deletePartition(String name) {
    final partition = _partitions[name];

    if (partition != null) {
      return partition
          .close(deleteFromDisk: true)
          .then((value) => _partitions.remove(name));
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

  /// Closes all partitions
  Future<void> close({bool deleteFromDisk = false}) {
    return Future.wait(_partitions.values
        .map((partition) => partition.close(deleteFromDisk: deleteFromDisk)));
  }
}

/// The [IsarVaultAdapter] provides a bridge between the store and the
/// Isar vault backend
class IsarVaultAdapter extends IsarAdapter<VaultModel> {
  /// [IsarVaultAdapter] constructor
  ///
  /// * [path]: The base location of the Isar partition
  /// * [maxSizeMib]: The max size Mib
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [compactOnLaunch]: The condition for the db to be compacted on launch
  /// * [inspector]: If the inspector is enabled
  IsarVaultAdapter._(String path,
      {super.maxSizeMib,
      super.relaxedDurability,
      super.compactOnLaunch,
      super.inspector})
      : super(VaultModelSchema, path);

  /// Builds [IsarVaultAdapter].
  ///
  /// * [path]: The base location of the Isar partition
  /// * [maxSizeMib]: The max size Mib
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [compactOnLaunch]: The condition for the db to be compacted on launch
  /// * [inspector]: If the inspector is enabled
  static Future<IsarVaultAdapter> build(String path,
      {int? maxSizeMib,
      bool? relaxedDurability,
      CompactCondition? compactOnLaunch,
      bool? inspector}) {
    return Future.value(IsarVaultAdapter._(path,
        maxSizeMib: maxSizeMib,
        relaxedDurability: relaxedDurability,
        compactOnLaunch: compactOnLaunch,
        inspector: inspector));
  }
}

/// The [IsarCacheAdapter] provides a bridge between the store and the
/// Isar cache backend
class IsarCacheAdapter extends IsarAdapter<CacheModel> {
  /// [IsarCacheAdapter] constructor
  ///
  /// * [path]: The base location of the Isar partition
  /// * [maxSizeMib]: The max size Mib
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [compactOnLaunch]: The condition for the db to be compacted on launch
  /// * [inspector]: If the inspector is enabled
  IsarCacheAdapter._(String path,
      {super.maxSizeMib,
      super.relaxedDurability,
      super.compactOnLaunch,
      super.inspector})
      : super(CacheModelSchema, path);

  /// Builds [IsarCacheAdapter].
  ///
  /// * [path]: The base location of the Isar partition
  /// * [maxSizeMib]: The max size Mib
  /// * [relaxedDurability]: Relaxed durability setting
  /// * [compactOnLaunch]: The condition for the db to be compacted on launch
  /// * [inspector]: If the inspector is enabled
  static Future<IsarCacheAdapter> build(String path,
      {int? maxSizeMib,
      bool? relaxedDurability,
      CompactCondition? compactOnLaunch,
      bool? inspector}) {
    return Future.value(IsarCacheAdapter._(path,
        maxSizeMib: maxSizeMib,
        relaxedDurability: relaxedDurability,
        compactOnLaunch: compactOnLaunch,
        inspector: inspector));
  }
}
