import 'package:meta/meta.dart';
import 'package:stash/stash_api.dart';

/// Base Sampler
abstract class BaseSampler implements KeySampler {
  /// The sampling factor
  final double _factor;

  /// Builds a [BaseSampler] with a optional [factor]
  ///
  /// * [factor]: The sampling factor
  const BaseSampler({double? factor})
      : assert(factor == null || (factor > 0.0 && factor <= 1.0)),
        _factor = factor ?? 1.0;

  @protected
  Iterable<String> sampleEntries(Iterable<String> entries, int sampleSize);

  /// Samples a collection of items
  ///
  /// * [entries]: The list of items to sample
  ///
  /// Returns a new collection sampled from the original
  @override
  Iterable<String> sample(Iterable<String> entries) {
    return sampleEntries(entries, (entries.length * _factor).truncate());
  }
}
