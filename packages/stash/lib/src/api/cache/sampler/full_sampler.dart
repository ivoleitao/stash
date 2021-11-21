import 'package:stash/src/api/cache/sampler/base_sampler.dart';

/// A sampler that doesn't perform any sampling
class FullSampler extends BaseSampler {
  /// Builds a new [FullSampler]
  const FullSampler();

  @override
  Iterable<String> sampleEntries(Iterable<String> entries, int sampleSize) {
    return entries;
  }
}
