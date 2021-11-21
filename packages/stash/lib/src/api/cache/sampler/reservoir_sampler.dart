import 'dart:math';

import 'package:stash/src/api/cache/sampler/base_sampler.dart';

/// An implementation of the reservoir sampling algorithm
class ReservoirSampler extends BaseSampler {
  /// The random generator
  final Random _random;

  /// Builds a new [RandomSampler]
  ///
  /// * [factor]: The sampling factor
  /// * [random]: The random generator
  ReservoirSampler(double factor, {Random? random})
      : _random = random ?? Random(),
        super(factor: factor);

  @override
  Iterable<String> sampleEntries(Iterable<String> entries, int sampleSize) {
    final elements = List<String>.from(entries);
    final sample = <String>[];

    var count = 0;
    for (var e in elements) {
      count++;
      if (sample.length <= sampleSize) {
        sample.add(e);
      } else {
        int index = _random.nextInt(count);
        if (index < sampleSize) {
          sample[index] = e;
        }
      }
    }

    return sample;
  }
}
