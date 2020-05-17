import 'package:stash/stash_harness.dart';
import 'package:stash/stash_memory.dart';
import 'package:test/test.dart';

void main() async {
  test('Bool', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, BoolGenerator(), deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore, newDefaultCache, BoolGenerator(), deleteMemoryStore);
  });

  test('Int', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, IntGenerator(), deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore, newDefaultCache, IntGenerator(), deleteMemoryStore);
  });

  test('Double', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, DoubleGenerator(), deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore, newDefaultCache, DoubleGenerator(), deleteMemoryStore);
  });

  test('String', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, StringGenerator(), deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore, newDefaultCache, StringGenerator(), deleteMemoryStore);
  });

  test('List<bool>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, IteratorGenerator(BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        IteratorGenerator(BoolGenerator()), deleteMemoryStore);
  });

  test('List<int>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore, IteratorGenerator(IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        IteratorGenerator(IntGenerator()), deleteMemoryStore);
  });

  test('List<double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        IteratorGenerator(DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        IteratorGenerator(DoubleGenerator()), deleteMemoryStore);
  });

  test('List<String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        IteratorGenerator(StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        IteratorGenerator(StringGenerator()), deleteMemoryStore);
  });

  test('Map<bool,bool>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(BoolGenerator(), BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(BoolGenerator(), BoolGenerator()), deleteMemoryStore);
  });

  test('Map<bool,int>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(BoolGenerator(), IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(BoolGenerator(), IntGenerator()), deleteMemoryStore);
  });

  test('Map<bool,double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(BoolGenerator(), DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(BoolGenerator(), DoubleGenerator()), deleteMemoryStore);
  });

  test('Map<bool,String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(BoolGenerator(), StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(BoolGenerator(), StringGenerator()), deleteMemoryStore);
  });

  test('Map<int,bool>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(IntGenerator(), BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(IntGenerator(), BoolGenerator()), deleteMemoryStore);
  });

  test('Map<int,int>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(IntGenerator(), IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(IntGenerator(), IntGenerator()), deleteMemoryStore);
  });

  test('Map<int,double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(IntGenerator(), DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(IntGenerator(), DoubleGenerator()), deleteMemoryStore);
  });

  test('Map<int,String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(IntGenerator(), StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(IntGenerator(), StringGenerator()), deleteMemoryStore);
  });

  test('Map<double,bool>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(DoubleGenerator(), BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(DoubleGenerator(), BoolGenerator()), deleteMemoryStore);
  });

  test('Map<double,int>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(DoubleGenerator(), IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(DoubleGenerator(), IntGenerator()), deleteMemoryStore);
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(DoubleGenerator(), DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(DoubleGenerator(), DoubleGenerator()), deleteMemoryStore);
  });

  test('Map<double,String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(DoubleGenerator(), StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(DoubleGenerator(), StringGenerator()), deleteMemoryStore);
  });

  test('Map<String,bool>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(StringGenerator(), BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(StringGenerator(), BoolGenerator()), deleteMemoryStore);
  });

  test('Map<String,int>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(StringGenerator(), IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(StringGenerator(), IntGenerator()), deleteMemoryStore);
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(StringGenerator(), DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(StringGenerator(), DoubleGenerator()), deleteMemoryStore);
  });

  test('Map<String,String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        MapGenerator(StringGenerator(), StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        MapGenerator(StringGenerator(), StringGenerator()), deleteMemoryStore);
  });

  test('Class<bool>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        SampleClassGenerator(BoolGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        SampleClassGenerator(BoolGenerator()), deleteMemoryStore);
  });

  test('Class<int>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        SampleClassGenerator(IntGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        SampleClassGenerator(IntGenerator()), deleteMemoryStore);
  });

  test('Class<double>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        SampleClassGenerator(DoubleGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        SampleClassGenerator(DoubleGenerator()), deleteMemoryStore);
  });

  test('Class<String>', () async {
    await testStoreWith<MemoryStore>(newMemoryStore,
        SampleClassGenerator(StringGenerator()), deleteMemoryStore);
    await testCacheWith<MemoryStore>(newMemoryStore, newDefaultCache,
        SampleClassGenerator(StringGenerator()), deleteMemoryStore);
  });

  test('Class<List<bool>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(IteratorGenerator(BoolGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(IteratorGenerator(BoolGenerator())),
        deleteMemoryStore);
  });

  test('Class<List<int>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(IteratorGenerator(IntGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(IteratorGenerator(IntGenerator())),
        deleteMemoryStore);
  });

  test('Class<List<double>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(IteratorGenerator(DoubleGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(IteratorGenerator(DoubleGenerator())),
        deleteMemoryStore);
  });

  test('Class<List<String>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(IteratorGenerator(StringGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(IteratorGenerator(StringGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<bool,bool>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<bool,int>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<bool,double>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(BoolGenerator(), DoubleGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(BoolGenerator(), DoubleGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<bool,String>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(BoolGenerator(), StringGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(BoolGenerator(), StringGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<int,bool>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<int,int>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<int,double>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<int,String>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<double,bool>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(DoubleGenerator(), BoolGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(DoubleGenerator(), BoolGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<double,int>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<double,double>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(
            MapGenerator(DoubleGenerator(), DoubleGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(
            MapGenerator(DoubleGenerator(), DoubleGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<double,String>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(
            MapGenerator(DoubleGenerator(), StringGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(
            MapGenerator(DoubleGenerator(), StringGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<String,bool>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(StringGenerator(), BoolGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(StringGenerator(), BoolGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<String,int>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<String,double>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(
            MapGenerator(StringGenerator(), DoubleGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(
            MapGenerator(StringGenerator(), DoubleGenerator())),
        deleteMemoryStore);
  });

  test('Class<Map<String,String>>', () async {
    await testStoreWith<MemoryStore>(
        newMemoryStore,
        SampleClassGenerator(
            MapGenerator(StringGenerator(), StringGenerator())),
        deleteMemoryStore);
    await testCacheWith<MemoryStore>(
        newMemoryStore,
        newDefaultCache,
        SampleClassGenerator(
            MapGenerator(StringGenerator(), StringGenerator())),
        deleteMemoryStore);
  });
}
