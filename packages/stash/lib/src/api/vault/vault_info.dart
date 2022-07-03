import 'package:stash/src/api/info.dart';

/// Base class with all the info fields for the Vault
class VaultInfo extends Info {
  /// Builds a [VaultInfo]
  ///
  /// * [key]: The vault key
  /// * [creationTime]: The vault creation time
  /// * [accessTime]: The vault access time
  /// * [updateTime]: The vault update time
  VaultInfo(super.key, super.creationTime,
      {super.accessTime, super.updateTime});
}
