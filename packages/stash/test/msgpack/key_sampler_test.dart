import 'package:stash/src/api/sampler/full_sampler.dart';
import 'package:stash/src/api/sampler/random_sampler.dart';
import 'package:test/test.dart';

void main() {
  void fullSamplerFull() {
    var fs = FullSampler();
    expect(fs.sampleSize(100), 100);
    expect(fs.sample(List.generate(1000, (i) => 'key_$i')).length, 1000);
  }

  void randomSamplerFull() {
    var rs = RandomSampler(1.00);
    expect(rs.sampleSize(100), 100);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 1000);
  }

  void randomSamplerHalf() {
    var rs = RandomSampler(0.50);
    expect(rs.sampleSize(100), 50);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 500);
  }

  void randomSamplerTheOnePercent() {
    var rs = RandomSampler(0.01);
    expect(rs.sampleSize(100), 1);
    expect(rs.sample(List.generate(1000, (i) => 'key_$i')).length, 10);
  }

  group('FullSampler', () {
    test('FullSamplerFull', fullSamplerFull);
  });

  group('RandomSampler', () {
    test('randomSamplerFull', randomSamplerFull);
    test('randomSamplerHalf', randomSamplerHalf);
    test('randomSamplerNone', randomSamplerTheOnePercent);
  });
}
