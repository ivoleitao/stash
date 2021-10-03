import 'entry.dart';
import 'vault_stat.dart';

/// The wrapper around the object that added to the vault
class VaultEntry extends Entry<VaultStat> {
  /// Builds a [VaultEntry]
  ///
  /// * [stat]: The entry stat
  /// * [value]: The entry value
  /// * [valueChanged]: If this value was changed
  VaultEntry._(VaultStat stat, dynamic value, bool? valueChanged)
      : super(stat, value, valueChanged);

  /// Creates a new [VaultEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  VaultEntry.newEntry(String key, DateTime creationTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime})
      : this._(
            VaultStat(key, creationTime,
                accessTime: accessTime, updateTime: updateTime),
            value,
            null);

  /// Updates a [VaultEntry]
  ///
  /// * [value]: The value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  VaultEntry updateEntry(dynamic value,
          {DateTime? accessTime, DateTime? updateTime}) =>
      VaultEntry._(
          VaultStat(key, creationTime,
              accessTime: accessTime,
              updateTime: updateTime ?? this.updateTime),
          value,
          true);
}
