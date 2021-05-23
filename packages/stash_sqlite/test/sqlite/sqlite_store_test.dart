import 'package:moor/moor.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_adapter.dart';
import 'package:stash_sqlite/src/sqlite/sqlite_store.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<SqliteStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SqliteStore> newStore() {
    return Future.value(SqliteStore(SqliteMemoryAdapter(logStatements: false),
        fromEncodable: fromEncodable));
  }
}

void main() async {
  moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
