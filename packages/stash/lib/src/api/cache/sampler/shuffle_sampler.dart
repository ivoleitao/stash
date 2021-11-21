import 'dart:math';

import 'package:stash/src/api/cache/sampler/base_sampler.dart';

/// A sampler that shuffles the elements from a list of keys and takes a
/// sample
class ShuffleSampler extends BaseSampler {
  /// The random generator
  final Random _random;

  /// Builds a new [ShuffleSampler]
  ///
  /// * [factor]: The sampling factor
  /// * [random]: The random generator
  ShuffleSampler(double factor, {Random? random})
      : _random = random ?? Random(),
        super(factor: factor);

  @override
  Iterable<String> sampleEntries(Iterable<String> entries, int sampleSize) {
    var samples = List<String>.from(entries)..shuffle(_random);
    return samples.take(sampleSize);
  }
}
