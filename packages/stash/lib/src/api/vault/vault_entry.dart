import 'package:stash/src/api/entry.dart';

import 'vault_info.dart';

/// The wrapper around the object that added to the vault
class VaultEntry extends Entry<VaultInfo> {
  /// Builds a [VaultEntry]
  ///
  /// * [info]: The entry info
  /// * [value]: The entry value
  /// * [state]: The entry state
  VaultEntry._(VaultInfo info, dynamic value, EntryState state)
      : super(info, value, state);

  /// Creates a new [VaultEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [value]: The cache value
  VaultEntry.addEntry(String key, DateTime creationTime, dynamic value)
      : this._(VaultInfo(key, creationTime), value, EntryState.added);

  /// Loads a new [VaultEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  VaultEntry.loadEntry(String key, DateTime creationTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime})
      : this._(
            VaultInfo(key, creationTime,
                accessTime: accessTime, updateTime: updateTime),
            value,
            EntryState.loaded);

  /// Updates the [VaultEntry] value
  ///
  /// * [value]: The cache value
  /// * [updateTime]: The cache update time
  VaultEntry updateValue(dynamic value, DateTime updateTime) {
    return VaultEntry._(
        VaultInfo(key, creationTime,
            accessTime: accessTime, updateTime: updateTime),
        value,
        EntryState.updatedValue);
  }
}
