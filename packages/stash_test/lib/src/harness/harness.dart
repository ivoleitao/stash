import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

/// [TestContext] builder function
typedef TestContextBuilder<T extends CacheStore> = TestContext<T> Function(
    ValueGenerator generator);

/// Store builder function
typedef StoreBuilder<T extends CacheStore> = Future<T> Function();

/// Cache builder function
typedef CacheBuilder<T extends CacheStore> = DefaultCache Function(T store,
    {String name,
    ExpiryPolicy expiryPolicy,
    KeySampler sampler,
    EvictionPolicy evictionPolicy,
    int maxEntries,
    CacheLoader cacheLoader,
    Clock clock});

/// The range of supported type tests
enum TypeTest {
  bool,
  int,
  double,
  string,
  listOfBool,
  listOfInt,
  listOfDouble,
  listOfString,
  mapOfBoolBool,
  mapOfBoolInt,
  mapOfBoolDouble,
  mapOfBoolString,
  mapOfIntBool,
  mapOfIntInt,
  mapOfIntDouble,
  mapOfIntString,
  mapOfDoubleBool,
  mapOfDoubleInt,
  mapOfDoubleDouble,
  mapOfDoubleString,
  mapOfStringBool,
  mapOfStringInt,
  mapOfStringDouble,
  mapOfStringString,
  classOfBool,
  classOfInt,
  classOfDouble,
  classOfString,
  classOfListBool,
  classOfListInt,
  classOfListDouble,
  classOfListString,
  classOfMapBoolBool,
  classOfMapBoolInt,
  classOfMapBoolDouble,
  classOfMapBoolString,
  classOfMapIntBool,
  classOfMapIntInt,
  classOfMapIntDouble,
  classOfMapIntString,
  classOfMapDoubleBool,
  classOfMapDoubleInt,
  classOfMapDoubleDouble,
  classOfMapDoubleString,
  classOfMapStringBool,
  classOfMapStringInt,
  classOfMapStringDouble,
  classOfMapStringString
}

extension TypeTestValue on TypeTest {
  ValueGenerator Function() get generator {
    switch (this) {
      case TypeTest.bool:
        return () => BoolGenerator();
      case TypeTest.int:
        return () => IntGenerator();
      case TypeTest.double:
        return () => DoubleGenerator();
      case TypeTest.string:
        return () => StringGenerator();
      case TypeTest.listOfBool:
        return () => IteratorGenerator(BoolGenerator());
      case TypeTest.listOfInt:
        return () => IteratorGenerator(IntGenerator());
      case TypeTest.listOfDouble:
        return () => IteratorGenerator(DoubleGenerator());
      case TypeTest.listOfString:
        return () => IteratorGenerator(StringGenerator());
      case TypeTest.mapOfBoolBool:
        return () => MapGenerator(BoolGenerator(), BoolGenerator());
      case TypeTest.mapOfBoolInt:
        return () => MapGenerator(BoolGenerator(), IntGenerator());
      case TypeTest.mapOfBoolDouble:
        return () => MapGenerator(BoolGenerator(), DoubleGenerator());
      case TypeTest.mapOfBoolString:
        return () => MapGenerator(BoolGenerator(), StringGenerator());
      case TypeTest.mapOfIntBool:
        return () => MapGenerator(IntGenerator(), BoolGenerator());
      case TypeTest.mapOfIntInt:
        return () => MapGenerator(IntGenerator(), IntGenerator());
      case TypeTest.mapOfIntDouble:
        return () => MapGenerator(IntGenerator(), DoubleGenerator());
      case TypeTest.mapOfIntString:
        return () => MapGenerator(IntGenerator(), StringGenerator());
      case TypeTest.mapOfDoubleBool:
        return () => MapGenerator(DoubleGenerator(), BoolGenerator());
      case TypeTest.mapOfDoubleInt:
        return () => MapGenerator(DoubleGenerator(), IntGenerator());
      case TypeTest.mapOfDoubleDouble:
        return () => MapGenerator(DoubleGenerator(), DoubleGenerator());
      case TypeTest.mapOfDoubleString:
        return () => MapGenerator(DoubleGenerator(), StringGenerator());
      case TypeTest.mapOfStringBool:
        return () => MapGenerator(StringGenerator(), BoolGenerator());
      case TypeTest.mapOfStringInt:
        return () => MapGenerator(StringGenerator(), IntGenerator());
      case TypeTest.mapOfStringDouble:
        return () => MapGenerator(StringGenerator(), DoubleGenerator());
      case TypeTest.mapOfStringString:
        return () => MapGenerator(StringGenerator(), StringGenerator());
      case TypeTest.classOfBool:
        return () => SampleClassGenerator(BoolGenerator());
      case TypeTest.classOfInt:
        return () => SampleClassGenerator(IntGenerator());
      case TypeTest.classOfDouble:
        return () => SampleClassGenerator(DoubleGenerator());
      case TypeTest.classOfString:
        return () => SampleClassGenerator(StringGenerator());
      case TypeTest.classOfListBool:
        return () => SampleClassGenerator(IteratorGenerator(BoolGenerator()));
      case TypeTest.classOfListInt:
        return () => SampleClassGenerator(IteratorGenerator(IntGenerator()));
      case TypeTest.classOfListDouble:
        return () => SampleClassGenerator(IteratorGenerator(DoubleGenerator()));
      case TypeTest.classOfListString:
        return () => SampleClassGenerator(IteratorGenerator(StringGenerator()));
      case TypeTest.classOfMapBoolBool:
        return () => SampleClassGenerator(
            MapGenerator(BoolGenerator(), BoolGenerator()));
      case TypeTest.classOfMapBoolInt:
        return () =>
            SampleClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()));
      case TypeTest.classOfMapBoolDouble:
        return () => SampleClassGenerator(
            MapGenerator(BoolGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapBoolString:
        return () => SampleClassGenerator(
            MapGenerator(BoolGenerator(), StringGenerator()));
      case TypeTest.classOfMapIntBool:
        return () =>
            SampleClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()));
      case TypeTest.classOfMapIntInt:
        return () =>
            SampleClassGenerator(MapGenerator(IntGenerator(), IntGenerator()));
      case TypeTest.classOfMapIntDouble:
        return () => SampleClassGenerator(
            MapGenerator(IntGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapIntString:
        return () => SampleClassGenerator(
            MapGenerator(IntGenerator(), StringGenerator()));
      case TypeTest.classOfMapDoubleBool:
        return () => SampleClassGenerator(
            MapGenerator(DoubleGenerator(), BoolGenerator()));
      case TypeTest.classOfMapDoubleInt:
        return () => SampleClassGenerator(
            MapGenerator(DoubleGenerator(), IntGenerator()));
      case TypeTest.classOfMapDoubleDouble:
        return () => SampleClassGenerator(
            MapGenerator(DoubleGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapDoubleString:
        return () => SampleClassGenerator(
            MapGenerator(DoubleGenerator(), StringGenerator()));
      case TypeTest.classOfMapStringBool:
        return () => SampleClassGenerator(
            MapGenerator(StringGenerator(), BoolGenerator()));
      case TypeTest.classOfMapStringInt:
        return () => SampleClassGenerator(
            MapGenerator(StringGenerator(), IntGenerator()));
      case TypeTest.classOfMapStringDouble:
        return () => SampleClassGenerator(
            MapGenerator(StringGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapStringString:
        return () => SampleClassGenerator(
            MapGenerator(StringGenerator(), StringGenerator()));
    }
  }
}

/// List of type tests
Map<TypeTest, ValueGenerator Function()> typeTests = {
  for (var test in TypeTest.values) test: test.generator
};

/// Assert that [actual] matches [matcher] in a specific test [ctx].
///
/// * [ctx]: The test context
/// * [actual]: The current value
/// * [matcher]: Can be a value in which case it will be wrapped in an equals matcher
/// * [reason]: If provided it is appended to the reason generated by the matcher
void check<T extends CacheStore>(
    TestContext<T> ctx, dynamic actual, dynamic matcher, String reason) {
  expect(actual, matcher, reason: 'Reason: $reason');
}

/// Creates a new [DefaultCache] bound to an implementation of the [CacheStore] interface
///
/// * [store]: The store implementation
/// * [name]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use
/// * [sampler]: The sampler to use upon eviction of a cache element
/// * [evictionPolicy]: The eviction policy to use
/// * [maxEntries]: The max number of entries this cache can hold if provided.
/// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon expiration
/// * [clock]: The source of time to be used
/// * [eventListenerMode]: The event listener mode of this cache
Cache newDefaultCache<T extends CacheStore>(T store,
    {String? name,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    Clock? clock,
    EventListenerMode? eventListenerMode}) {
  return Cache.newCache(store,
      name: name,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      clock: clock,
      eventListenerMode: eventListenerMode);
}

/// Generic definition of a value generator
abstract class ValueGenerator {
  /// Returns a new value out of a provided [seed]
  ///
  /// * [seed]: The seed used to generate a new value
  ///
  /// Returns a new value generated from the provided [seed]
  dynamic nextValue(int seed);

  /// Returns the encoder for the generated class
  dynamic Function(Map<String, dynamic> json)? get fromEncodable => null;
}

/// A [bool] implementation of a [ValueGenerator] which produces a [bool] from a provided seed
class BoolGenerator extends ValueGenerator {
  @override
  dynamic nextValue(int seed) {
    return seed % 2 == 0;
  }
}

/// A [int] implementation of a [ValueGenerator] which produces a [int] from a provided seed
class IntGenerator extends ValueGenerator {
  @override
  dynamic nextValue(int seed) {
    return seed;
  }
}

/// A [double] implementation of a [ValueGenerator] which produces a [double] from a provided seed
class DoubleGenerator extends ValueGenerator {
  @override
  dynamic nextValue(int seed) {
    return seed.toDouble();
  }
}

/// A [String] implementation of a [ValueGenerator] which produces a [String] from a provided seed
/// and a optional prefix
class StringGenerator extends ValueGenerator {
  /// The prefix for the generated [String]
  final String _prefix;

  /// Builds a [StringGenerator] with a optional [prefix]
  ///
  /// * [prefix]: The prefix of the generated strings, default to 'String'
  StringGenerator({String? prefix}) : _prefix = prefix ?? 'String';

  @override
  dynamic nextValue(int seed) {
    return '$_prefix-$seed';
  }
}

/// A [Iterator] implementation of a [ValueGenerator] which produces a [Iterator] from a provided seed
/// and a element [ValueGenerator]
class IteratorGenerator extends ValueGenerator {
  /// The generator used for each of the elements of the [Iterator]
  final ValueGenerator _ithGenerator;

  /// Builds a [IteratorGenerator] with a provided element generator, [_ithGenerator]
  ///
  /// * [_ithGenerator]: The [Iterator] element generator
  IteratorGenerator(this._ithGenerator);

  @override
  dynamic nextValue(int seed) {
    var generated = [];

    for (var i = 0; i <= seed; i++) {
      generated.add(_ithGenerator.nextValue(seed));
    }

    return generated;
  }
}

/// A [Map] implementation of a [ValueGenerator] which produces a [Map] from a provided seed
class MapGenerator extends ValueGenerator {
  /// The generator used for the key of the [Map]
  final ValueGenerator _keyIthGenerator;

  /// The generator used for the value of the [Map]
  final ValueGenerator _valueIthGenerator;

  /// Builds a [MapGenerator] with a provided key generator [_keyIthGenerator]
  ///
  /// * [_keyIthGenerator]: The key generator
  /// * [_valueIthGenerator]: The value generator
  MapGenerator(this._keyIthGenerator, this._valueIthGenerator);

  @override
  dynamic nextValue(int seed) {
    var generated = {};

    for (var i = 0; i <= seed; i++) {
      generated[_keyIthGenerator.nextValue(seed)] =
          _valueIthGenerator.nextValue(seed);
    }

    return generated;
  }
}

/// A sample class used to test class serialization / deserialization scenarios
class SampleClass with EquatableMixin {
  /// The stored value
  final dynamic value;

  /// Builds a [SampleClass]
  ///
  /// * [value]: An optional value
  SampleClass({this.value});

  @override
  List<Object> get props => [value];

  /// Creates a [SampleClass] from json map
  factory SampleClass.fromJson(Map<String, dynamic> json) =>
      SampleClass(value: json['value']);

  /// Creates a json map from a [SampleClass]
  Map<String, dynamic> toJson() => <String, dynamic>{'value': value};
}

/// A [SampleClass] implementation of a [ValueGenerator] which produces a [SampleClass] from a provided seed
class SampleClassGenerator extends ValueGenerator {
  /// The generator used for the [SampleClass] value
  final ValueGenerator _ithGenerator;

  /// Builds a [SampleClassGenerator] with a provided [SampleClass.value] element generator, [_ithGenerator]
  ///
  /// * [_ithGenerator]: The [SampleClass.value] generator
  SampleClassGenerator(this._ithGenerator);

  @override
  dynamic nextValue(int seed) {
    return SampleClass(value: _ithGenerator.nextValue(seed));
  }

  @override
  Function(Map<String, dynamic> json) get fromEncodable =>
      (Map<String, dynamic> json) => SampleClass.fromJson(json);
}

/// Base class for all the test contexts.
abstract class TestContext<T extends CacheStore> {
  /// A value generator
  final ValueGenerator generator;

  /// Function called on encodable object to obtain the underlining type
  final dynamic Function(Map<String, dynamic>)? fromEncodable;

  /// Builds a new [TestContext]
  ///
  /// * [generator]: A value generator
  /// * [fromEncodable]: An optional function to convert a json map into a object
  TestContext(this.generator, {this.fromEncodable});

  /// Creates a new store
  Future<T> newStore();

  /// Creates a new cache
  ///
  /// * [store]: The [CacheStore]
  /// * [name]: The name of the cache
  /// * [expiryPolicy]: The expiry policy to use
  /// * [sampler]: The sampler to use upon eviction of a cache element
  /// * [evictionPolicy]: The eviction policy to use
  /// * [maxEntries]: The max number of entries this cache can hold if provided.
  /// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon expiration
  /// * [clock]: The source of time to be used on this
  /// * [eventListenerMode]: The event listener mode of this cache
  Cache newCache(T store,
      {String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode}) {
    return newDefaultCache(store,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock,
        eventListenerMode: eventListenerMode);
  }

  /// Deletes a store
  ///
  /// * [store]: The [CacheStore]
  Future<void> deleteStore(T store) {
    return store.deleteAll();
  }
}

/// Creates a new [CacheEntry] with the provided [ValueGenerator] and [seed]
///
/// * [generator]: The [ValueGenerator] to use
/// * [seed]: The seed for the [ValueGenerator]
/// * [key]: The cache key
/// * [expiryTime]: The cache expiry time
/// * [creationTime]: The cache creation time
/// * [accessTime]: The cache accessTime
/// * [updateTime]: The cache update time
/// * [hitCount]: The cache hit count
///
/// Returns a fully initialized [CacheEntry]
CacheEntry newEntry(ValueGenerator generator, int seed,
    {String? key,
    DateTime? expiryTime,
    DateTime? creationTime,
    DateTime? accessTime,
    DateTime? updateTime,
    int? hitCount}) {
  return CacheEntry(key ?? 'cache_key_$seed', generator.nextValue(seed),
      expiryTime ?? seed.minutes.fromNow, creationTime ?? DateTime.now(),
      accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
}
