import 'package:stash_sembast/stash_sembast.dart';
import 'package:stash_sembast_web/stash_sembast_web.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<SembastStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SembastStore> newStore() {
    return Future.value(SembastStore(SembastWebAdapter('sembast_web'),
        fromEncodable: fromEncodable));
  }
}

void main() async {
  final sembastTypeTests =
      Map<TypeTest, ValueGenerator Function()>.from(typeTests)
        ..remove(TypeTest.mapOfBoolBool)
        ..remove(TypeTest.mapOfBoolInt)
        ..remove(TypeTest.mapOfBoolDouble)
        ..remove(TypeTest.mapOfBoolString)
        ..remove(TypeTest.mapOfIntBool)
        ..remove(TypeTest.mapOfIntInt)
        ..remove(TypeTest.mapOfIntDouble)
        ..remove(TypeTest.mapOfIntString)
        ..remove(TypeTest.mapOfDoubleBool)
        ..remove(TypeTest.mapOfDoubleInt)
        ..remove(TypeTest.mapOfDoubleDouble)
        ..remove(TypeTest.mapOfDoubleString)
        ..remove(TypeTest.classOfMapBoolBool)
        ..remove(TypeTest.classOfMapBoolInt)
        ..remove(TypeTest.classOfMapBoolDouble)
        ..remove(TypeTest.classOfMapBoolString)
        ..remove(TypeTest.classOfMapIntBool)
        ..remove(TypeTest.classOfMapIntInt)
        ..remove(TypeTest.classOfMapIntDouble)
        ..remove(TypeTest.classOfMapIntString)
        ..remove(TypeTest.classOfMapDoubleBool)
        ..remove(TypeTest.classOfMapDoubleInt)
        ..remove(TypeTest.classOfMapDoubleDouble)
        ..remove(TypeTest.classOfMapDoubleString);

  testStore((generator) => DefaultContext(generator), types: sembastTypeTests);
  testCache((generator) => DefaultContext(generator), types: sembastTypeTests);
}
