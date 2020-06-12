import 'package:quiver/time.dart';
import 'package:stash/src/api/cache/default_cache.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';
import 'package:stash/src/api/expiry/expiry_policy.dart';
import 'package:stash/src/api/sampler/sampler.dart';
import 'package:stash/stash_harness.dart';
import 'package:stash/stash_memory.dart';
import 'package:test/test.dart';

class MemoryContext extends TestContext<MemoryStore> {
  MemoryContext(ValueGenerator generator) : super(generator);

  @override
  Future<MemoryStore> newStore() {
    return newMemoryStore();
  }

  @override
  DefaultCache newCache(MemoryStore store,
      {String name,
      ExpiryPolicy expiryPolicy,
      KeySampler sampler,
      EvictionPolicy evictionPolicy,
      int maxEntries,
      cacheLoader,
      Clock clock}) {
    return newDefaultCache(store,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock);
  }

  @override
  void check(actual, matcher, {String reason, skip}) {
    expect(actual, matcher, reason: reason, skip: skip);
  }
}

void main() async {
  test('Bool', () async {
    await testStoreWith<MemoryStore>(MemoryContext(BoolGenerator()));
    await testCacheWith<MemoryStore>(MemoryContext(BoolGenerator()));
  });

  test('Int', () async {
    await testStoreWith<MemoryStore>(MemoryContext(IntGenerator()));
    await testCacheWith<MemoryStore>(MemoryContext(IntGenerator()));
  });

  test('Double', () async {
    await testStoreWith<MemoryStore>(MemoryContext(DoubleGenerator()));
    await testCacheWith<MemoryStore>(MemoryContext(DoubleGenerator()));
  });

  test('String', () async {
    await testStoreWith<MemoryStore>(MemoryContext(StringGenerator()));
    await testCacheWith<MemoryStore>(MemoryContext(StringGenerator()));
  });

  test('List<bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(IteratorGenerator(BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(IteratorGenerator(BoolGenerator())));
  });

  test('List<int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(IteratorGenerator(IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(IteratorGenerator(IntGenerator())));
  });

  test('List<double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(IteratorGenerator(DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(IteratorGenerator(DoubleGenerator())));
  });

  test('List<String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(IteratorGenerator(StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(IteratorGenerator(StringGenerator())));
  });

  test('Map<bool,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), BoolGenerator())));
  });

  test('Map<bool,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), IntGenerator())));
  });

  test('Map<bool,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
  });

  test('Map<bool,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(BoolGenerator(), StringGenerator())));
  });

  test('Map<int,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), BoolGenerator())));
  });

  test('Map<int,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), IntGenerator())));
  });

  test('Map<int,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), DoubleGenerator())));
  });

  test('Map<int,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(IntGenerator(), StringGenerator())));
  });

  test('Map<double,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
  });

  test('Map<double,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
  });

  test('Map<double,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(DoubleGenerator(), StringGenerator())));
  });

  test('Map<String,bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), BoolGenerator())));
  });

  test('Map<String,int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), DoubleGenerator())));
  });

  test('Map<String,String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(MapGenerator(StringGenerator(), StringGenerator())));
  });

  test('Class<bool>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(BoolGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(BoolGenerator())));
  });

  test('Class<int>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(IntGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(IntGenerator())));
  });

  test('Class<double>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(DoubleGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(DoubleGenerator())));
  });

  test('Class<String>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(StringGenerator())));
    await testCacheWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(StringGenerator())));
  });

  test('Class<List<bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
  });

  test('Class<List<int>>', () async {
    await testStoreWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    await testCacheWith<MemoryStore>(
        MemoryContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
  });

  test('Class<List<double>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
  });

  test('Class<List<String>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
  });

  test('Class<Map<bool,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
  });

  test('Class<Map<bool,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
  });

  test('Class<Map<bool,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<bool,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
  });

  test('Class<Map<int,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
  });

  test('Class<Map<int,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
  });

  test('Class<Map<int,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<int,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
  });

  test('Class<Map<double,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
  });

  test('Class<Map<double,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
  });

  test('Class<Map<double,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<double,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
  });

  test('Class<Map<String,bool>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
  });

  test('Class<Map<String,int>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
  });

  test('Class<Map<String,double>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<String,String>>', () async {
    await testStoreWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    await testCacheWith<MemoryStore>(MemoryContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
  });
}
