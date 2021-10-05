import 'package:stash_memory/stash_memory.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends CacheTestContext<MemoryCacheStore> {
  DefaultContext(ValueGenerator generator) : super(generator);

  @override
  Future<MemoryCacheStore> newStore() {
    return Future.value(newMemoryCacheStore());
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
