import 'package:stash/src/api/expiry/expiry_policy.dart';

/// An [ExpiryPolicy] that defines the expiry [Duration]
/// of a Cache Entry based on the last time it was accessed. Accessed
/// does not include a cache update.
class AccessedExpiryPolicy extends ExpiryPolicy {
  /// The [Duration] a Cache Entry should be available before it expires.
  final Duration _expiryDuration;

  /// Builds a [AccessedExpiryPolicy] [ExpiryPolicy]
  ///
  /// * [_expiryDuration]: the [Duration] a cache entry should exist before it expires after being accessed
  const AccessedExpiryPolicy(this._expiryDuration)
      : assert(_expiryDuration != null);

  @override
  Duration getExpiryForCreation() {
    // The initial expiry duration is the same as if the entry was accessed
    return _expiryDuration;
  }

  @override
  Duration getExpiryForAccess() {
    // When a cache entry is accessed, we return the specified expiry duration,
    // ignoring the current expiry duration
    return _expiryDuration;
  }

  @override
  Duration getExpiryForUpdate() {
    // Modifying a cache entry has no affect on the current expiry duration
    return null;
  }
}
