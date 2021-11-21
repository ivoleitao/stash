import 'package:stash/src/api/cache/sampler/full_sampler.dart';
import 'package:stash/src/api/cache/sampler/shuffle_sampler.dart';
import 'package:test/test.dart';

void main() {
  void fullSampler() {
    final fs = FullSampler();
    expect(fs.sample(List.generate(1000, (i) => 'key_$i')).length, 1000);
  }

  void shuffleSamplerFull() {
    var rs = ShuffleSampler(1.00);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 1000);
  }

  void shuffleSamplerHalf() {
    var rs = ShuffleSampler(0.50);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 500);
  }

  void shuffleSamplerTheOnePercent() {
    final rs = ShuffleSampler(0.01);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 10);
  }

  group('FullSampler', () {
    test('FullSamplerFull', fullSampler);
  });

  group('ShuffleSampler', () {
    test('shuffleSamplerFull', shuffleSamplerFull);
    test('shuffleSamplerHalf', shuffleSamplerHalf);
    test('shuffleSamplerTheOnePercent', shuffleSamplerTheOnePercent);
  });
}
