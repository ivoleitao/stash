import 'package:stash_memory/stash_memory.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<MemoryStore> {
  DefaultContext(ValueGenerator generator) : super(generator);

  @override
  Future<MemoryStore> newStore() {
    return Future.value(MemoryStore());
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
