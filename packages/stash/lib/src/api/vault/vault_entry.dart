import 'package:stash/src/api/entry.dart';

import 'vault_info.dart';

/// The wrapper around the object that added to the vault
class VaultEntry extends Entry<VaultInfo> {
  /// Builds a [VaultEntry]
  ///
  /// * [info]: The entry info
  /// * [value]: The entry value
  /// * [valueChanged]: If this value was changed
  VaultEntry._(VaultInfo info, dynamic value, bool? valueChanged)
      : super(info, value, valueChanged);

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
            VaultInfo(key, creationTime,
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
          VaultInfo(key, creationTime,
              accessTime: accessTime,
              updateTime: updateTime ?? this.updateTime),
          value,
          true);
}
