import 'package:stash/src/api/cache/sampler/sampler.dart';

/// A [KeySampler] that doesn't perform any sampling
class FullSampler extends KeySampler {
  /// Builds a new [FullSampler]
  const FullSampler();

  @override
  Iterable<String> sample(Iterable<String> items) {
    return items;
  }
}
