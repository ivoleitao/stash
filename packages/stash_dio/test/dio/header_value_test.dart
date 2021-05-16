import 'package:stash_dio/src/dio/header_value.dart';
import 'package:test/test.dart';

void main() async {
  test('Header value parsing', () {
    expect(
        HeaderValue.parseCacheControl(
                'no-cache, no-store, max-age=0, must-revalidate')
            .parameters,
        {
          'no-cache': null,
          'no-store': null,
          'max-age': '0',
          'must-revalidate': null
        });
  });
}
