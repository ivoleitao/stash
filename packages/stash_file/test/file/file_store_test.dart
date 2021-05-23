import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:stash_file/stash_file.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<FileStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  Future<FileStore> _newMemoryStore() {
    FileSystem fs = MemoryFileSystem();

    return Future.value(FileStore(fs, fs.systemTempDirectory.path,
        lock: false, fromEncodable: fromEncodable));
  }

  @override
  Future<FileStore> newStore() {
    return _newMemoryStore();
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
