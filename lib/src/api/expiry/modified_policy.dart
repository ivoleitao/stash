import 'package:stash/src/api/expiry/expiry_policy.dart';

/// An [ExpiryPolicy] that defines the expiry [Duration]
/// of a Cache Entry based on the last time it was updated.
/// Updating includes created and changing (updating) an entry.
class ModifiedExpiryPolicy extends ExpiryPolicy {
  /// The [Duration] a Cache Entry should be available before it expires.
  final Duration _expiryDuration;

  /// Builds a [ModifiedExpiryPolicy] [ExpiryPolicy]
  ///
  /// * [_expiryDuration]: the [Duration] a Cache Entry should exist be before it expires after being modified
  const ModifiedExpiryPolicy(this._expiryDuration);

  @override
  Duration getExpiryForCreation() {
    // For newly created entries we use the specified expiry duration
    return _expiryDuration;
  }

  @override
  Duration? getExpiryForAccess() {
    // Accessing a cache entry has no affect on the current expiry duration
    return null;
  }

  @override
  Duration getExpiryForUpdate() {
    // When a cache entry is modified, we return the specified expiry duration,
    // ignoring the current expiry duration
    return _expiryDuration;
  }
}
