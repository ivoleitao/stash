import 'dart:io';

import 'package:stash/stash_harness.dart';
import 'package:stash_sembast/stash_sembast.dart';
import 'package:test/test.dart';

class DefaultContext extends TestContext<SembastStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: fromEncodable);

  @override
  Future<SembastStore> newStore() {
    return Directory.systemTemp
        .createTemp('stash_sembast')
        .then((d) => SembastStore(d.path, fromEncodable: fromEncodable));
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
    await testStoreWith<SembastStore>(DefaultContext(BoolGenerator()));
    await testCacheWith<SembastStore>(DefaultContext(BoolGenerator()));
  });

  test('Int', () async {
    await testStoreWith<SembastStore>(DefaultContext(IntGenerator()));
    await testCacheWith<SembastStore>(DefaultContext(IntGenerator()));
  });

  test('Double', () async {
    await testStoreWith<SembastStore>(DefaultContext(DoubleGenerator()));
    await testCacheWith<SembastStore>(DefaultContext(DoubleGenerator()));
  });

  test('String', () async {
    await testStoreWith<SembastStore>(DefaultContext(StringGenerator()));
    await testCacheWith<SembastStore>(DefaultContext(StringGenerator()));
  });

  test('List<bool>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(IteratorGenerator(BoolGenerator())));
  });

  test('List<int>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(IteratorGenerator(IntGenerator())));
  });

  test('List<double>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(IteratorGenerator(DoubleGenerator())));
  });

  test('List<String>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(IteratorGenerator(StringGenerator())));
  });

  test('Map<bool,bool>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), BoolGenerator())));
  }, skip: 'Map<bool,bool> is not supported by sembast');

  test('Map<bool,int>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), IntGenerator())));
  }, skip: 'Map<bool, int> is not supported by sembast');

  test('Map<bool,double>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), DoubleGenerator())));
  }, skip: 'Map<bool,double> is not supported by sembast');

  test('Map<bool,String>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(BoolGenerator(), StringGenerator())));
  }, skip: 'Map<bool,String> is not supported by sembast');

  test('Map<int,bool>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), BoolGenerator())));
  }, skip: 'Map<int,bool> is not supported by sembast');

  test('Map<int,int>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), IntGenerator())));
  }, skip: 'Map<int,int> is not supported by sembast');

  test('Map<int,double>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), DoubleGenerator())));
  }, skip: 'Map<int,double> is not supported by sembast');

  test('Map<int,String>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(IntGenerator(), StringGenerator())));
  }, skip: 'Map<int,String> is not supported by sembast');

  test('Map<double,bool>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), BoolGenerator())));
  }, skip: 'Map<double,bool> is not supported by sembast');

  test('Map<double,int>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), IntGenerator())));
  }, skip: 'Map<double,int> is not supported by sembast');

  test('Map<double,double>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), DoubleGenerator())));
  }, skip: 'Map<double,double> is not supported by sembast');

  test('Map<double,String>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(DoubleGenerator(), StringGenerator())));
  }, skip: 'Map<double,String> is not supported by sembast');

  test('Map<String,bool>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), BoolGenerator())));
  });

  test('Map<String,int>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), IntGenerator())));
  });

  test('Map<double,double>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), DoubleGenerator())));
  });

  test('Map<String,String>', () async {
    await testStoreWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
    await testCacheWith<SembastStore>(
        DefaultContext(MapGenerator(StringGenerator(), StringGenerator())));
  });

  test('Class<bool>', () async {
    await testStoreWith<SembastStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
    await testCacheWith<SembastStore>(
        ObjectContext(SampleClassGenerator(BoolGenerator())));
  });

  test('Class<int>', () async {
    await testStoreWith<SembastStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
    await testCacheWith<SembastStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
  });

  test('Class<double>', () async {
    await testStoreWith<SembastStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
    await testCacheWith<SembastStore>(
        ObjectContext(SampleClassGenerator(DoubleGenerator())));
  });

  test('Class<String>', () async {
    await testStoreWith<SembastStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
    await testCacheWith<SembastStore>(
        ObjectContext(SampleClassGenerator(StringGenerator())));
  });

  test('Class<List<bool>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(BoolGenerator()))));
  });

  test('Class<List<int>>', () async {
    await testStoreWith<SembastStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
    await testCacheWith<SembastStore>(
        ObjectContext(SampleClassGenerator(IteratorGenerator(IntGenerator()))));
  });

  test('Class<List<double>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(DoubleGenerator()))));
  });

  test('Class<List<String>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(IteratorGenerator(StringGenerator()))));
  });

  test('Class<Map<bool,bool>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()))));
  }, skip: 'Class<Map<bool,bool>> is not supported by Sembast');

  test('Class<Map<bool,int>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()))));
  }, skip: 'Class<Map<bool,int>> is not supported by Sembast');

  test('Class<Map<bool,double>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), DoubleGenerator()))));
  }, skip: 'Class<Map<bool,double>> is not supported by Sembast');

  test('Class<Map<bool,String>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(BoolGenerator(), StringGenerator()))));
  }, skip: 'Class<Map<bool,String>> is not supported by Sembast');

  test('Class<Map<int,bool>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()))));
  }, skip: 'Class<Map<int,bool>> is not supported by Sembast');

  test('Class<Map<int,int>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()))));
  }, skip: 'Class<Map<int,int>> is not supported by Sembast');

  test('Class<Map<int,double>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), DoubleGenerator()))));
  }, skip: 'Class<Map<int,double>> is not supported by Sembast');

  test('Class<Map<int,String>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(IntGenerator(), StringGenerator()))));
  }, skip: 'Class<Map<int,String>> is not supported by Sembast');

  test('Class<Map<double,bool>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), BoolGenerator()))));
  }, skip: 'Class<Map<double,bool>> is not supported by Sembast');

  test('Class<Map<double,int>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(DoubleGenerator(), IntGenerator()))));
  }, skip: 'Class<Map<double,int>> is not supported by Sembast');

  test('Class<Map<double,double>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), DoubleGenerator()))));
  }, skip: 'Class<Map<double,double>> is not supported by Sembast');

  test('Class<Map<double,String>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(DoubleGenerator(), StringGenerator()))));
  }, skip: 'Class<Map<double,String>> is not supported by Sembast');

  test('Class<Map<String,bool>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), BoolGenerator()))));
  });

  test('Class<Map<String,int>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(
        SampleClassGenerator(MapGenerator(StringGenerator(), IntGenerator()))));
  });

  test('Class<Map<String,double>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), DoubleGenerator()))));
  });

  test('Class<Map<String,String>>', () async {
    await testStoreWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
    await testCacheWith<SembastStore>(ObjectContext(SampleClassGenerator(
        MapGenerator(StringGenerator(), StringGenerator()))));
  });
}
