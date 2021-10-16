/// Defines a strategy to sample elements from a collection
abstract class KeySampler {
  /// The sampling factor
  final double _factor;

  /// Builds a [KeySampler] with a optional [factor]
  ///
  /// * [factor]: The sampling factor
  const KeySampler({double? factor})
      : assert(factor == null || (factor > 0.0 && factor <= 1.0)),
        _factor = factor ?? 1.0;

  /// Returns the sample size
  ///
  /// * [size]: The size of the collection to sample
  int sampleSize(int size) => (size * _factor).truncate();

  /// Samples a collection of items
  ///
  /// * [items]: The list of items to sample
  ///
  /// Returns a new collection sampled from the original
  Iterable<String> sample(Iterable<String> items);
}
