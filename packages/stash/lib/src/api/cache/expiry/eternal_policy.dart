import 'package:stash/src/api/cache/expiry/expiry_policy.dart';

///An eternal [ExpiryPolicy] specifies that Cache Entries
/// won't expire.  This however doesn't mean they won't be evicted if an
/// underlying implementation needs to free-up resources where by it may
/// choose to evict entries that are not due to expire.
class EternalExpiryPolicy extends ExpiryPolicy {
  /// Builds a [EternalExpiryPolicy]
  const EternalExpiryPolicy();

  @override
  Duration getExpiryForCreation() {
    return ExpiryPolicy.eternal;
  }

  @override
  Duration? getExpiryForAccess() {
    return null;
  }

  @override
  Duration? getExpiryForUpdate() {
    return null;
  }
}
