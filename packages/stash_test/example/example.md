```dart
import 'package:stash_custom/stash_custom.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<CustomStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<FileStore> newStore() {
    return Future.value(CustomStore(..., fromEncodable: fromEncodable));
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
```