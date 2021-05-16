import 'package:stash_test/stash_test.dart';
import 'package:test/test.dart';

void main() async {
  test('BoolGenerator', () async {
    final generator = BoolGenerator();
    expect(generator.nextValue(1), false);
    expect(generator.nextValue(2), true);
  });
}
