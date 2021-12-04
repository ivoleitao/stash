import 'package:stash/src/api/info.dart';

/// Base class with all the info fields for the Vault
class VaultInfo extends Info {
  /// Builds a [VaultInfo]
  ///
  /// * [key]: The vault key
  /// * [creationTime]: The vault creation time
  /// * [type]: The vault type
  /// * [accessTime]: The vault access time
  /// * [updateTime]: The vault update time
  VaultInfo(String key, DateTime creationTime,
      {int? type, DateTime? accessTime, DateTime? updateTime})
      : super(key, creationTime,
            type: type, accessTime: accessTime, updateTime: updateTime);
}
