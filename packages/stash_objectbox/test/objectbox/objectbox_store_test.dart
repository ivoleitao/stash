import 'dart:io';

import 'package:stash/stash_harness.dart';
import 'package:stash_objectbox/stash_objectbox.dart';
import 'package:test/test.dart';

class DefaultContext extends TestContext<ObjectboxStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: fromEncodable);

  @override
  Future<ObjectboxStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_objectbox')
        .then((d) => ObjectboxStore(fromEncodable: fromEncodable));
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
    /*
    await testStoreWith<ObjectboxStore>(DefaultContext(BoolGenerator()));
    await testCacheWith<ObjectboxStore>(DefaultContext(BoolGenerator()));
    */
  });

  test('Int', () async {
    /*
    await testStoreWith<ObjectboxStore>(DefaultContext(IntGenerator()));
    await testCacheWith<ObjectboxStore>(DefaultContext(IntGenerator()));
    */
  });

  test('Double', () async {
    /*
    await testStoreWith<ObjectboxStore>(DefaultContext(DoubleGenerator()));
    await testCacheWith<ObjectboxStore>(DefaultContext(DoubleGenerator()));
    */
  });

  test('String', () async {
    /*
    await testStoreWith<ObjectboxStore>(DefaultContext(StringGenerator()));
    await testCacheWith<ObjectboxStore>(DefaultContext(StringGenerator()));
    */
  });

  test('List<bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
    */
  });

  test('List<int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
    */
  });

  test('List<double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
    */
  });

  test('List<String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
    */
  });

  test('Map<bool,bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    */
  });

  test('Map<bool,int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
    */
  });

  test('Map<bool,double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    */
  });

  test('Map<bool,String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
    */
  });

  test('Map<int,bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
    */
  });

  test('Map<int,int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
    */
  });

  test('Map<int,double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    */
  });

  test('Map<int,String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
    */
  });

  test('Map<double,bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    */
  });

  test('Map<double,int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    */
  });

  test('Map<double,double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    */
  });

  test('Map<double,String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    */
  });

  test('Map<String,bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
    */
  });

  test('Map<String,int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
    */
  });

  test('Map<double,double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    */
  });

  test('Map<String,String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
    */
  });

  test('Class<bool>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
    await testCacheWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
    */
  });

  test('Class<int>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
    await testCacheWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
    */
  });

  test('Class<double>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
    await testCacheWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
    */
  });

  test('Class<String>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
    await testCacheWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
    */
  });

  test('Class<List<bool>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    */
  });

  test('Class<List<int>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    await testCacheWith<ObjectboxStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    */
  });

  test('Class<List<double>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    */
  });

  test('Class<List<String>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    */
  });

  test('Class<Map<bool,bool>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    */
  });

  test('Class<Map<bool,int>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    */
  });

  test('Class<Map<bool,double>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    */
  });

  test('Class<Map<bool,String>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    */
  });

  test('Class<Map<int,bool>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    */
  });

  test('Class<Map<int,int>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    */
  });

  test('Class<Map<int,double>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    */
  });

  test('Class<Map<int,String>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    */
  });

  test('Class<Map<double,bool>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    */
  });

  test('Class<Map<double,int>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    */
  });

  test('Class<Map<double,double>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    */
  });

  test('Class<Map<double,String>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    */
  });

  test('Class<Map<String,bool>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    */
  });

  test('Class<Map<String,int>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    */
  });

  test('Class<Map<String,double>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    */
  });

  test('Class<Map<String,String>>', () async {
    /*
    await testStoreWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    await testCacheWith<ObjectboxStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    */
  });
}
