import 'dart:io';

import 'package:stash/stash_harness.dart';
import 'package:stash_hive/stash_hive.dart';
import 'package:test/test.dart';

class DefaultContext extends TestContext<HiveStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: fromEncodable);

  @override
  Future<HiveStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_hive')
        .then((d) => HiveStore(d.path, fromEncodable: fromEncodable));
  }

  @override
  void check(actual, matcher, {String? reason, skip}) {
    expect(actual, matcher, reason: reason, skip: skip);
  }
}

class ObjectContext extends DefaultContext {
  ObjectContext(ValueGenerator generator)
      : super(generator,
            fromEncodable: (Map<String, dynamic> json) =>
                SampleClass.fromJson(json));
}

void main() async {
  test('Boolean', () async {
    await testStoreWith<HiveStore>(DefaultContext(BoolGenerator()));
    await testCacheWith<HiveStore>(DefaultContext(BoolGenerator()));
  });

  test('Int', () async {
    await testStoreWith<HiveStore>(DefaultContext(IntGenerator()));
    await testCacheWith<HiveStore>(DefaultContext(IntGenerator()));
  });

  test('Double', () async {
    await testStoreWith<HiveStore>(DefaultContext(DoubleGenerator()));
    await testCacheWith<HiveStore>(DefaultContext(DoubleGenerator()));
  });

  test('String', () async {
    await testStoreWith<HiveStore>(DefaultContext(StringGenerator()));
    await testCacheWith<HiveStore>(DefaultContext(StringGenerator()));
  });

  test('List<bool>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
  });

  test('List<int>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
  });

  test('List<double>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
  });

  test('List<String>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
  });

  test('Map<bool,bool>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
  });

  test('Map<bool,int>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
  });

  test('Map<bool,double>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
  });

  test('Map<bool,String>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
  });

  test('Map<int,bool>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
  });

  test('Map<int,int>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
  });

  test('Map<int,double>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
  });

  test('Map<int,String>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
  });
  test('Map<double,bool>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
  });

  test('Map<double,int>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
  });

  test('Map<double,String>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
  });

  test('Map<String,bool>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
  });

  test('Map<String,int>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
  });

  test('Map<String,String>', () async {
    await testStoreWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
    await testCacheWith<HiveStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
  });

  test('Class<bool>', () async {
    await testStoreWith<HiveStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
    await testCacheWith<HiveStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
  });

  test('Class<int>', () async {
    await testStoreWith<HiveStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
    await testCacheWith<HiveStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
  });

  test('Class<double>', () async {
    await testStoreWith<HiveStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
    await testCacheWith<HiveStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
  });

  test('Class<String>', () async {
    await testStoreWith<HiveStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
    await testCacheWith<HiveStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
  });

  test('Class<List<bool>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
  });

  test('Class<List<int>>', () async {
    await testStoreWith<HiveStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    await testCacheWith<HiveStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
  });

  test('Class<List<double>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
  });

  test('Class<List<String>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
  });

  test('Class<Map<bool,bool>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
  });

  test('Class<Map<bool,int>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
  });

  test('Class<Map<bool,double>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<bool,String>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
  });

  test('Class<Map<int,bool>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
  });

  test('Class<Map<int,int>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
  });

  test('Class<Map<int,double>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<int,String>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
  });

  test('Class<Map<double,bool>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
  });

  test('Class<Map<double,int>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
  });

  test('Class<Map<double,double>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<double,String>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
  });

  test('Class<Map<String,bool>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
  });

  test('Class<Map<String,int>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
  });

  test('Class<Map<String,double>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<String,String>>', () async {
    await testStoreWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    await testCacheWith<HiveStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
  });
}
