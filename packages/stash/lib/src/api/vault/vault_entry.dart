import 'package:stash/src/api/entry.dart';

import 'vault_info.dart';

/// The wrapper around the object that added to the vault
class VaultEntry extends Entry<VaultInfo> {
  /// Builds a [VaultEntry]
  ///
  /// * [info]: The entry info
  /// * [value]: The entry value
  /// * [state]: The entry state
  VaultEntry._(super.info, super.value, super.state);

  /// Builds a new [VaultEntry]
  ///
  /// * [builder]: The [VaultEntry] builder
  VaultEntry._builder(VaultEntryBuilder builder)
      : this._(
            VaultInfo(builder.key, builder.creationTime,
                accessTime: builder.accessTime, updateTime: builder.updateTime),
            builder.value,
            builder.state);

  /// Creates a loaded [VaultEntry]
  ///
  /// * [key]: The vault key
  /// * [creationTime]: The vault creation time
  /// * [value]: The vault value
  /// * [accessTime]: The vault access time
  /// * [updateTime]: The vault update time
  VaultEntry.loaded(String key, DateTime creationTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime})
      : this._(
            VaultInfo(key, creationTime,
                accessTime: accessTime, updateTime: updateTime),
            value,
            EntryState.loaded);

  /// Creates an updated [VaultEntry]
  ///
  /// * [info]: The vault info of the original entry
  /// * [value]: The cache value
  /// * [updateTime]: The cache update time
  VaultEntry.updated(VaultInfo info, dynamic value, DateTime updateTime)
      : this._(
            VaultInfo(info.key, info.creationTime,
                accessTime: info.accessTime, updateTime: updateTime),
            value,
            EntryState.updated);
}

/// The [VaultEntry] builder
class VaultEntryBuilder<T> extends EntryBuilder<T, VaultInfo, VaultEntry> {
  /// Builds a [VaultEntryBuilder]
  ///
  /// * [key]: The entry key
  /// * [value]: The entry value
  /// * [creationTime]: The entry creation time
  /// * [accessTime]: The access time
  /// * [updateTime]: The update time
  VaultEntryBuilder(super.key, super.value, super.creationTime);

  @override
  VaultEntry build() {
    return VaultEntry._builder(this);
  }
}
