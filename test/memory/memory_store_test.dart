import 'package:stash/stash_harness.dart';
import 'package:stash/stash_memory.dart';
import 'package:test/test.dart';

class MemoryStoreContext extends TestContext<MemoryStore> {
  MemoryStoreContext(ValueGenerator generator)
      : super(generator,
            storeBuilder: newMemoryStore, cacheBuilder: newDefaultCache);

  @override
  void check(actual, matcher, {String reason, skip}) {
    expect(actual, matcher, reason: reason, skip: skip);
  }
}

void main() async {
  test('Bool', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(BoolGenerator()));
    await testCacheWith<MemoryStore>(MemoryStoreContext(BoolGenerator()));
  });

  test('Int', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(IntGenerator()));
    await testCacheWith<MemoryStore>(MemoryStoreContext(IntGenerator()));
  });

  test('Double', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(DoubleGenerator()));
    await testCacheWith<MemoryStore>(MemoryStoreContext(DoubleGenerator()));
  });

  test('String', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(StringGenerator()));
    await testCacheWith<MemoryStore>(MemoryStoreContext(StringGenerator()));
  });

  test('List<bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(BoolGenerator())));
  });

  test('List<int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(IntGenerator())));
  });

  test('List<double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(DoubleGenerator())));
  });

  test('List<String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(IteratorGenerator(StringGenerator())));
  });

  test('Map<bool,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), BoolGenerator())));
  });

  test('Map<bool,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), IntGenerator())));
  });

  test('Map<bool,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
  });

  test('Map<bool,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(BoolGenerator(), StringGenerator())));
  });

  test('Map<int,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), BoolGenerator())));
  });

  test('Map<int,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), IntGenerator())));
  });

  test('Map<int,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), DoubleGenerator())));
  });

  test('Map<int,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(IntGenerator(), StringGenerator())));
  });

  test('Map<double,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
  });

  test('Map<double,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
  });

  test('Map<double,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(DoubleGenerator(), StringGenerator())));
  });

  test('Map<String,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), BoolGenerator())));
  });

  test('Map<String,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), DoubleGenerator())));
  });

  test('Map<String,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(MapGenerator(StringGenerator(), StringGenerator())));
  });

  test('Class<bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(BoolGenerator())));
  });

  test('Class<int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(IntGenerator())));
  });

  test('Class<double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(DoubleGenerator())));
  });

  test('Class<String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryStoreContext(SampleClassGenerator(StringGenerator())));
  });

  test('Class<List<bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
  });

  test('Class<List<int>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(IntGenerator()))));
  });

  test('Class<List<double>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
  });

  test('Class<List<String>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
  });

  test('Class<Map<bool,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
  });

  test('Class<Map<bool,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
  });

  test('Class<Map<bool,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<bool,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
  });

  test('Class<Map<int,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
  });

  test('Class<Map<int,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
  });

  test('Class<Map<int,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<int,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
  });

  test('Class<Map<double,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
  });

  test('Class<Map<double,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
  });

  test('Class<Map<double,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<double,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
  });

  test('Class<Map<String,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
  });

  test('Class<Map<String,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
  });

  test('Class<Map<String,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<String,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryStoreContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
  });
}
