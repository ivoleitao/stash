/// Defines a strategy to sample elements from a collection
abstract class KeySampler {
  /// Samples a collection of entries
  ///
  /// * [entries]: The list of entries to sample
  ///
  /// Returns a new collection sampled from the original
  Iterable<String> sample(Iterable<String> entries);
}
