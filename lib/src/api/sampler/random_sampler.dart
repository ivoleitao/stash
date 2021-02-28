import 'dart:math';

import 'package:stash/src/api/sampler/sampler.dart';

/// A [KeySampler] that randomly samples the elements from a list of keys
class RandomSampler extends KeySampler {
  /// The random generator
  final Random _random;

  /// Builds a new [RandomSampler]
  ///
  /// * [factor]: The sampling factor
  /// * [random]: The random generator
  RandomSampler(double factor, {Random random})
      : _random = random ?? Random(),
        super(factor: factor);

  @override
  Iterable<String> sample(Iterable<String> items) {
    var samples = List<String>.from(items)..shuffle(_random);

    var count = sampleSize(items.length);
    for (var item in items.take(count)) {
      samples.add(item);
    }

    return samples;
  }
}
