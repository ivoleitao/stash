import 'package:stash_file/stash_file.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends CacheTestContext<FileCacheStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<FileCacheStore> _newMemoryStore() {
    return Future.value(newFileMemoryCacheStore(fromEncodable: fromEncodable));
  }

  @override
  Future<FileCacheStore> newStore() {
    return _newMemoryStore();
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
