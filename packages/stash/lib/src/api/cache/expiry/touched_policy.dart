import 'package:stash/src/api/cache/expiry/expiry_policy.dart';

/// An [ExpiryPolicy] that defines the expiry [Duration]
/// of a Cache Entry based on when it was last touched. A touch includes
/// creation, update or access.
class TouchedExpiryPolicy extends ExpiryPolicy {
  /// The [Duration] a Cache Entry should be available before it expires.
  final Duration _expiryDuration;

  /// Builds an [TouchedExpiryPolicy] [ExpiryPolicy]
  ///
  /// * [_expiryDuration]: the [Duration] a Cache Entry should exist be before it expires after being modified
  const TouchedExpiryPolicy(this._expiryDuration);

  @override
  Duration getExpiryForCreation() {
    // For newly created entries we use the specified expiry duration.
    return _expiryDuration;
  }

  @override
  Duration getExpiryForAccess() {
    // Accessing a cache entry resets the duration.
    return _expiryDuration;
  }

  @override
  Duration getExpiryForUpdate() {
    // Updating a cache entry resets the duration.
    return _expiryDuration;
  }
}
