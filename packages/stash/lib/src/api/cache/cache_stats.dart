import 'package:stash/src/api/stats.dart';

/// The [Stats] definition for a cache
abstract class CacheStats extends Stats {
  /// This is a measure of cache efficiency.
  ///
  /// It is calculated as:
  /// * [gets] divided by [requests] * 100.
  ///
  /// Returns the percentage of successful gets, as a decimal e.g 75
  double get getPercentage;

  /// A miss is a get request that is not satisfied. In a simple cache a miss
  /// occurs when the cache does not satisfy the request. Note that `containsKey`
  /// is not a get request for statistics purposes.
  ///
  /// Returns the number of misses
  int get misses;

  /// Increases the counter by the number specified.
  ///
  /// * [number] the number to increase the counter by
  void increaseMisses({int number});

  /// Returns the percentage of cache accesses that did not find a
  /// requested entry in the cache.
  ///
  /// It is calculated as:
  /// * [misses] divided by [requests] * 100.
  ///
  ///
  /// Returns the percentage of accesses that failed to find anything
  double get missPercentage;

  /// The total number of requests to the cache. This will be equal to the sum of
  /// the gets and misses.
  ///
  /// Returns the number of requests to the cache
  int get requests;

  /// The total number of cache expiries.
  ///
  /// Returns the number of expiries
  int get expiries;

  /// Increases the counter by the number specified.
  ///
  /// * [number]: the number to increase the counter by
  void increaseExpiries({int number = 1});

  /// The total number of evictions from the cache. An eviction is a removal
  /// initiated by the cache itself to free up space. An eviction is not
  /// treated as a removal and does not appear in the removal counts.
  ///
  /// Returns the number of evictions
  int get evictions;

  /// Increases the counter by the number specified.
  ///
  /// * [number]: the number to increase the counter by
  void increaseEvictions({int number = 1});
}
