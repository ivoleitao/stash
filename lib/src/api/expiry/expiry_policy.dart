/// Defines functions to determine when cache entries will expire based on
/// creation, access and modification operations.
///
/// Each of the functions return a new [Duration] that specifies the
/// amount of time that must pass before a cache entry is considered expired.
abstract class ExpiryPolicy {
  /// The value used to represent a eternal duration
  static const Duration eternal = Duration(days: 8999999999999999991);

  /// Builds a [ExpiryPolicy]
  const ExpiryPolicy();

  /// Gets the [Duration] before a newly created [CacheEntry] is considered
  /// expired.
  ///
  /// This method is called by a caching implementation after a [CacheEntry] is
  /// created, but before a [CacheEntry] is added to a cache, to determine the
  /// [Duration] before an entry expires.  If a [Duration.zero] is returned
  /// the new [CacheEntry] is considered to be already expired and will not
  /// be added to the Cache.
  ///
  /// Returns the new [Duration] before a created entry expires
  Duration getExpiryForCreation();

  /// Gets the [Duration] before an accessed [CacheEntry] is considered expired.
  ///
  /// This method is called by a caching implementation after a [CacheEntry] is
  /// accessed to determine the [Duration] before an entry expires.  If a
  /// [Duration.zero] is returned a [CacheEntry] will be considered immediately expired.
  /// Returning `null` will result in no change to the previously understood expiry
  /// [Duration]
  ///
  /// Returns the new [Duration] before an accessed entry expires
  Duration getExpiryForAccess();

  /// Gets the [Duration] before an updated [CacheEntry] is considered expired.
  ///
  /// This method is called by the caching implementation after a [CacheEntry] is
  /// updated to determine the [Duration] before the updated entry expires.
  /// If a [Duration.zero] is returned a [CacheEntry] is considered immediately
  /// expired.  Returning `null` will result in no change to the previously
  /// understood expiry [Duration].
  ///
  /// Returns the new [Duration] before an updated entry expires
  Duration getExpiryForUpdate();
}
