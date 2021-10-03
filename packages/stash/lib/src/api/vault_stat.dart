import 'package:stash/src/api/stat.dart';

/// Base class with all the stat fields for the Vault
class VaultStat extends Stat {
  /// Builds a [VaultStat]
  ///
  /// * [key]: The vault key
  /// * [creationTime]: The vault creation time
  /// * [accessTime]: The vault access time
  /// * [updateTime]: The vault update time
  VaultStat(String key, DateTime creationTime,
      {DateTime? accessTime, DateTime? updateTime})
      : super(key, creationTime,
            accessTime: accessTime, updateTime: updateTime);
}
