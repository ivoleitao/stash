import 'package:stash_sembast/src/sembast/sembast_adapter.dart';
import 'package:stash_sembast/stash_sembast.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<SembastStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SembastStore> newStore() {
    return Future.value(SembastStore(SembastMemoryAdapter('sembast'),
        fromEncodable: fromEncodable));
  }
}

void main() async {
  final sembastTypeTests =
      Map<TypeTest, ValueGenerator Function()>.from(TypeTests)
        ..remove(TypeTest.MapOfBoolBool)
        ..remove(TypeTest.MapOfBoolInt)
        ..remove(TypeTest.MapOfBoolDouble)
        ..remove(TypeTest.MapOfBoolString)
        ..remove(TypeTest.MapOfIntBool)
        ..remove(TypeTest.MapOfIntInt)
        ..remove(TypeTest.MapOfIntDouble)
        ..remove(TypeTest.MapOfIntString)
        ..remove(TypeTest.MapOfDoubleBool)
        ..remove(TypeTest.MapOfDoubleInt)
        ..remove(TypeTest.MapOfDoubleDouble)
        ..remove(TypeTest.MapOfDoubleString)
        ..remove(TypeTest.ClassOfMapBoolBool)
        ..remove(TypeTest.ClassOfMapBoolInt)
        ..remove(TypeTest.ClassOfMapBoolDouble)
        ..remove(TypeTest.ClassOfMapBoolString)
        ..remove(TypeTest.ClassOfMapIntBool)
        ..remove(TypeTest.ClassOfMapIntInt)
        ..remove(TypeTest.ClassOfMapIntDouble)
        ..remove(TypeTest.ClassOfMapIntString)
        ..remove(TypeTest.ClassOfMapDoubleBool)
        ..remove(TypeTest.ClassOfMapDoubleInt)
        ..remove(TypeTest.ClassOfMapDoubleDouble)
        ..remove(TypeTest.ClassOfMapDoubleString);

  testStore((generator) => DefaultContext(generator), types: sembastTypeTests);
  testCache((generator) => DefaultContext(generator), types: sembastTypeTests);
}
