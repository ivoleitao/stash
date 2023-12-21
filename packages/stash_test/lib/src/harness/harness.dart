import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

/// [TestContext] builder function
typedef TestContextBuilder<I extends Info, E extends Entry<I>,
        T extends Store<I, E>>
    = TestContext<I, E, T> Function(ValueGenerator generator);

/// [VaultTestContext] builder function
typedef VaultTestContextBuilder<T extends Store<VaultInfo, VaultEntry>>
    = VaultTestContext<T> Function(ValueGenerator generator);

/// [CacheTestContext] builder function
typedef CacheTestContextBuilder<T extends Store<CacheInfo, CacheEntry>>
    = CacheTestContext<T> Function(ValueGenerator generator);

/// Store builder function
typedef StoreBuilder<I extends Info, E extends Entry<I>, T extends Store<I, E>>
    = Future<T> Function();

/// Cache builder function
typedef CacheBuilder<T extends Store<CacheInfo, CacheEntry>>
    = GenericCache Function(T store,
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
  classOfMapStringString,

  classOfClassOfBool,
  classOfClassOfInt,
  classOfClassOfDouble,
  classOfClassOfString,
  classOfClassOfListBool,
  classOfClassOfListInt,
  classOfClassOfListDouble,
  classOfClassOfListString,
  classOfClassOfMapBoolBool,
  classOfClassOfMapBoolInt,
  classOfClassOfMapBoolDouble,
  classOfClassOfMapBoolString,
  classOfClassOfMapIntBool,
  classOfClassOfMapIntInt,
  classOfClassOfMapIntDouble,
  classOfClassOfMapIntString,
  classOfClassOfMapDoubleBool,
  classOfClassOfMapDoubleInt,
  classOfClassOfMapDoubleDouble,
  classOfClassOfMapDoubleString,
  classOfClassOfMapStringBool,
  classOfClassOfMapStringInt,
  classOfClassOfMapStringDouble,
  classOfClassOfMapStringString
}

extension TypeTestValue on TypeTest {
  ValueGenerator Function() get generator {
    switch (this) {
      // Scalar
      case TypeTest.bool:
        return () => BoolGenerator();
      case TypeTest.int:
        return () => IntGenerator();
      case TypeTest.double:
        return () => DoubleGenerator();
      case TypeTest.string:
        return () => StringGenerator();
      // List
      case TypeTest.listOfBool:
        return () => IteratorGenerator(BoolGenerator());
      case TypeTest.listOfInt:
        return () => IteratorGenerator(IntGenerator());
      case TypeTest.listOfDouble:
        return () => IteratorGenerator(DoubleGenerator());
      case TypeTest.listOfString:
        return () => IteratorGenerator(StringGenerator());
      // Map
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
      // Class of scalar
      case TypeTest.classOfBool:
        return () => ValueClassGenerator(BoolGenerator());
      case TypeTest.classOfInt:
        return () => ValueClassGenerator(IntGenerator());
      case TypeTest.classOfDouble:
        return () => ValueClassGenerator(DoubleGenerator());
      case TypeTest.classOfString:
        return () => ValueClassGenerator(StringGenerator());
      // Class of list
      case TypeTest.classOfListBool:
        return () => ValueClassGenerator(IteratorGenerator(BoolGenerator()));
      case TypeTest.classOfListInt:
        return () => ValueClassGenerator(IteratorGenerator(IntGenerator()));
      case TypeTest.classOfListDouble:
        return () => ValueClassGenerator(IteratorGenerator(DoubleGenerator()));
      case TypeTest.classOfListString:
        return () => ValueClassGenerator(IteratorGenerator(StringGenerator()));
      // Class of map
      case TypeTest.classOfMapBoolBool:
        return () =>
            ValueClassGenerator(MapGenerator(BoolGenerator(), BoolGenerator()));
      case TypeTest.classOfMapBoolInt:
        return () =>
            ValueClassGenerator(MapGenerator(BoolGenerator(), IntGenerator()));
      case TypeTest.classOfMapBoolDouble:
        return () => ValueClassGenerator(
            MapGenerator(BoolGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapBoolString:
        return () => ValueClassGenerator(
            MapGenerator(BoolGenerator(), StringGenerator()));
      case TypeTest.classOfMapIntBool:
        return () =>
            ValueClassGenerator(MapGenerator(IntGenerator(), BoolGenerator()));
      case TypeTest.classOfMapIntInt:
        return () =>
            ValueClassGenerator(MapGenerator(IntGenerator(), IntGenerator()));
      case TypeTest.classOfMapIntDouble:
        return () => ValueClassGenerator(
            MapGenerator(IntGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapIntString:
        return () => ValueClassGenerator(
            MapGenerator(IntGenerator(), StringGenerator()));
      case TypeTest.classOfMapDoubleBool:
        return () => ValueClassGenerator(
            MapGenerator(DoubleGenerator(), BoolGenerator()));
      case TypeTest.classOfMapDoubleInt:
        return () => ValueClassGenerator(
            MapGenerator(DoubleGenerator(), IntGenerator()));
      case TypeTest.classOfMapDoubleDouble:
        return () => ValueClassGenerator(
            MapGenerator(DoubleGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapDoubleString:
        return () => ValueClassGenerator(
            MapGenerator(DoubleGenerator(), StringGenerator()));
      case TypeTest.classOfMapStringBool:
        return () => ValueClassGenerator(
            MapGenerator(StringGenerator(), BoolGenerator()));
      case TypeTest.classOfMapStringInt:
        return () => ValueClassGenerator(
            MapGenerator(StringGenerator(), IntGenerator()));
      case TypeTest.classOfMapStringDouble:
        return () => ValueClassGenerator(
            MapGenerator(StringGenerator(), DoubleGenerator()));
      case TypeTest.classOfMapStringString:
        return () => ValueClassGenerator(
            MapGenerator(StringGenerator(), StringGenerator()));
      // Class of class of scalar
      case TypeTest.classOfClassOfBool:
        return () =>
            ContainerClassGenerator(ValueClassGenerator(BoolGenerator()));
      case TypeTest.classOfClassOfInt:
        return () =>
            ContainerClassGenerator(ValueClassGenerator(IntGenerator()));
      case TypeTest.classOfClassOfDouble:
        return () =>
            ContainerClassGenerator(ValueClassGenerator(DoubleGenerator()));
      case TypeTest.classOfClassOfString:
        return () =>
            ContainerClassGenerator(ValueClassGenerator(StringGenerator()));
      // Class of class of list
      case TypeTest.classOfClassOfListBool:
        return () => ContainerClassGenerator(
            ValueClassGenerator(IteratorGenerator(BoolGenerator())));
      case TypeTest.classOfClassOfListInt:
        return () => ContainerClassGenerator(
            ValueClassGenerator(IteratorGenerator(IntGenerator())));
      case TypeTest.classOfClassOfListDouble:
        return () => ContainerClassGenerator(
            ValueClassGenerator(IteratorGenerator(DoubleGenerator())));
      case TypeTest.classOfClassOfListString:
        return () => ContainerClassGenerator(
            ValueClassGenerator(IteratorGenerator(StringGenerator())));
      // Class of class of map
      case TypeTest.classOfClassOfMapBoolBool:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(BoolGenerator(), BoolGenerator())));
      case TypeTest.classOfClassOfMapBoolInt:
        return () => ContainerClassGenerator(
            ValueClassGenerator(MapGenerator(BoolGenerator(), IntGenerator())));
      case TypeTest.classOfClassOfMapBoolDouble:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(BoolGenerator(), DoubleGenerator())));
      case TypeTest.classOfClassOfMapBoolString:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(BoolGenerator(), StringGenerator())));
      case TypeTest.classOfClassOfMapIntBool:
        return () => ContainerClassGenerator(
            ValueClassGenerator(MapGenerator(IntGenerator(), BoolGenerator())));
      case TypeTest.classOfClassOfMapIntInt:
        return () => ContainerClassGenerator(
            ValueClassGenerator(MapGenerator(IntGenerator(), IntGenerator())));
      case TypeTest.classOfClassOfMapIntDouble:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(IntGenerator(), DoubleGenerator())));
      case TypeTest.classOfClassOfMapIntString:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(IntGenerator(), StringGenerator())));
      case TypeTest.classOfClassOfMapDoubleBool:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(DoubleGenerator(), BoolGenerator())));
      case TypeTest.classOfClassOfMapDoubleInt:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(DoubleGenerator(), IntGenerator())));
      case TypeTest.classOfClassOfMapDoubleDouble:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(DoubleGenerator(), DoubleGenerator())));
      case TypeTest.classOfClassOfMapDoubleString:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(DoubleGenerator(), StringGenerator())));
      case TypeTest.classOfClassOfMapStringBool:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(StringGenerator(), BoolGenerator())));
      case TypeTest.classOfClassOfMapStringInt:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(StringGenerator(), IntGenerator())));
      case TypeTest.classOfClassOfMapStringDouble:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(StringGenerator(), DoubleGenerator())));
      case TypeTest.classOfClassOfMapStringString:
        return () => ContainerClassGenerator(ValueClassGenerator(
            MapGenerator(StringGenerator(), StringGenerator())));
    }
  }
}

/// All type tests
Map<TypeTest, ValueGenerator Function()> allTypeTests = {
  for (var test in TypeTest.values) test: test.generator
};

/// Default store type tests
Map<TypeTest, ValueGenerator Function()> defaultStoreTypeTests = {
  // Scalar
  TypeTest.bool: TypeTest.bool.generator,
  TypeTest.int: TypeTest.int.generator,
  TypeTest.double: TypeTest.double.generator,
  TypeTest.string: TypeTest.string.generator,
  // List
  TypeTest.listOfBool: TypeTest.listOfBool.generator,
  TypeTest.listOfInt: TypeTest.listOfInt.generator,
  TypeTest.listOfDouble: TypeTest.listOfDouble.generator,
  TypeTest.listOfString: TypeTest.listOfString.generator,
  // Map
  TypeTest.mapOfStringBool: TypeTest.mapOfStringBool.generator,
  TypeTest.mapOfStringInt: TypeTest.mapOfStringInt.generator,
  TypeTest.mapOfStringDouble: TypeTest.mapOfStringDouble.generator,
  TypeTest.mapOfStringString: TypeTest.mapOfStringString.generator,
  // Class of scalar
  TypeTest.classOfBool: TypeTest.classOfBool.generator,
  TypeTest.classOfInt: TypeTest.classOfInt.generator,
  TypeTest.classOfDouble: TypeTest.classOfDouble.generator,
  TypeTest.classOfString: TypeTest.classOfString.generator,
  // Class of list
  TypeTest.classOfListBool: TypeTest.classOfListBool.generator,
  TypeTest.classOfListInt: TypeTest.classOfListInt.generator,
  TypeTest.classOfListDouble: TypeTest.classOfListDouble.generator,
  TypeTest.classOfListString: TypeTest.classOfListString.generator,
  // Class of map
  TypeTest.classOfMapStringBool: TypeTest.classOfMapStringBool.generator,
  TypeTest.classOfMapStringInt: TypeTest.classOfMapStringInt.generator,
  TypeTest.classOfMapStringDouble: TypeTest.classOfMapStringDouble.generator,
  TypeTest.classOfMapStringString: TypeTest.classOfMapStringString.generator,
  // Class of class of scalar
  TypeTest.classOfClassOfBool: TypeTest.classOfClassOfBool.generator,
  TypeTest.classOfClassOfInt: TypeTest.classOfClassOfInt.generator,
  TypeTest.classOfClassOfDouble: TypeTest.classOfClassOfDouble.generator,
  TypeTest.classOfClassOfString: TypeTest.classOfClassOfString.generator,
  // Class of class of list
  TypeTest.classOfClassOfListBool: TypeTest.classOfClassOfListBool.generator,
  TypeTest.classOfClassOfListInt: TypeTest.classOfClassOfListInt.generator,
  TypeTest.classOfClassOfListDouble:
      TypeTest.classOfClassOfListDouble.generator,
  TypeTest.classOfClassOfListString:
      TypeTest.classOfClassOfListString.generator,
  // Class of class of map
  TypeTest.classOfClassOfMapStringBool:
      TypeTest.classOfClassOfMapStringBool.generator,
  TypeTest.classOfClassOfMapStringInt:
      TypeTest.classOfClassOfMapStringInt.generator,
  TypeTest.classOfClassOfMapStringDouble:
      TypeTest.classOfClassOfMapStringDouble.generator,
  TypeTest.classOfClassOfMapStringString:
      TypeTest.classOfClassOfMapStringString.generator,
};

/// Default stash type tests
Map<TypeTest, ValueGenerator Function()> defaultStashTypeTests = {
  TypeTest.bool: TypeTest.bool.generator,
  TypeTest.listOfInt: TypeTest.listOfInt.generator,
  TypeTest.mapOfDoubleDouble: TypeTest.mapOfDoubleDouble.generator,
  TypeTest.classOfString: TypeTest.classOfString.generator,
  TypeTest.classOfListBool: TypeTest.classOfListBool.generator,
  TypeTest.classOfMapStringString: TypeTest.classOfMapStringString.generator,
  TypeTest.classOfClassOfString: TypeTest.classOfClassOfString.generator,
  TypeTest.classOfClassOfListBool: TypeTest.classOfClassOfListBool.generator,
  TypeTest.classOfClassOfMapStringString:
      TypeTest.classOfClassOfMapStringString.generator,
};

/// Assert that [actual] matches [matcher] in a specific test [ctx].
///
/// * [ctx]: The test context
/// * [actual]: The current value
/// * [matcher]: Can be a value in which case it will be wrapped in an equals matcher
/// * [reason]: If provided it is appended to the reason generated by the matcher
void check<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
    TestContext<I, E, T> ctx, dynamic actual, dynamic matcher, String reason) {
  expect(actual, matcher, reason: 'Reason: $reason');
}

/// Creates a [Vault] bound to an implementation of the [Store] interface
///
/// * [store]: The store implementation
/// * [name]: The name of the vault
/// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
/// * [vaultLoader]: The [VaultLoader], that should be used to fetch a new value upon absence
/// * [clock]: The source of time to be used
/// * [eventListenerMode]: The event listener mode of this vault
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Future<Vault<V>> newGenericVault<V, T extends Store<VaultInfo, VaultEntry>>(
    T store,
    {String? name,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    VaultLoader<V>? vaultLoader,
    Clock? clock,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    VaultStats? stats}) {
  return DefaultVaultManager().newGenericVault(store,
      name: name,
      fromEncodable: fromEncodable,
      vaultLoader: vaultLoader,
      clock: clock,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Creates a new [GenericCache] bound to an implementation of the [Store] interface
///
/// * [store]: The store implementation
/// * [name]: The name of the cache
/// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
/// * [expiryPolicy]: The expiry policy to use
/// * [sampler]: The sampler to use upon eviction of a cache element
/// * [evictionPolicy]: The eviction policy to use
/// * [maxEntries]: The max number of entries this cache can hold if provided.
/// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon absence or expiration
/// * [clock]: The source of time to be used
/// * [eventListenerMode]: The event listener mode of this cache
/// * [statsEnabled]: If statistics should be collected, defaults to false
/// * [stats]: The statistics instance
Future<Cache<V>> newGenericCache<V, T extends Store<CacheInfo, CacheEntry>>(
    T store,
    {String? name,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader<V>? cacheLoader,
    Clock? clock,
    EventListenerMode? eventListenerMode,
    bool? statsEnabled,
    CacheStats? stats}) {
  return DefaultCacheManager().newGenericCache(store,
      name: name,
      fromEncodable: fromEncodable,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      clock: clock,
      eventListenerMode: eventListenerMode,
      statsEnabled: statsEnabled,
      stats: stats);
}

/// Generic definition of a value generator
abstract class ValueGenerator {
  /// Returns a new value out of a provided [seed]
  ///
  /// * [seed]: The seed used to generate a new value
  ///
  /// Returns a new value generated from the provided [seed]
  dynamic nextValue(int seed);

  /// Returns a new value out of a provided [seed] and casts it to [T]
  ///
  /// * [seed]: The seed used to generate a new value
  ///
  /// Returns a new value generated from the provided [seed] as [T]
  T nextValueAs<T>(int seed) {
    return nextValue(seed) as T;
  }

  /// Returns a new value out of a provided [seed] as a list and casts the list
  /// type to [T]
  ///
  /// * [seed]: The seed used to generate a new value
  ///
  /// Returns a new list generated from the provided [seed] as a List<[T]>
  List<T> nextListOf<T>(int seed) {
    return (nextValueAs(seed) as List).cast<T>();
  }

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

/// A value class used to test class serialization / deserialization scenarios
class ValueClass with EquatableMixin {
  /// The stored value
  final dynamic value;

  /// Builds a [ValueClass]
  ///
  /// * [value]: An optional value
  ValueClass({this.value});

  @override
  List<Object> get props => [value];

  /// Creates a [ValueClass] from json map
  factory ValueClass.fromJson(Map<String, dynamic> json) =>
      ValueClass(value: json['value']);

  /// Creates a json map from a [ValueClass]
  Map<String, dynamic> toJson() => <String, dynamic>{'value': value};
}

/// A [ValueClass] implementation of a [ValueGenerator] which produces a [ValueClass] from a provided seed
class ValueClassGenerator extends ValueGenerator {
  /// The generator used for the [ValueClass] value
  final ValueGenerator _ithGenerator;

  /// Builds a [ValueClassGenerator] with a provided [ValueClass.value] element generator, [_ithGenerator]
  ///
  /// * [_ithGenerator]: The [ValueClass.value] generator
  ValueClassGenerator(this._ithGenerator);

  @override
  dynamic nextValue(int seed) {
    return ValueClass(value: _ithGenerator.nextValue(seed));
  }

  @override
  Function(Map<String, dynamic> json) get fromEncodable =>
      (Map<String, dynamic> json) => ValueClass.fromJson(json);
}

/// A container class used to test class serialization / deserialization scenarios
class ContainerClass with EquatableMixin {
  /// The stored value
  final ValueClass? value;

  /// Builds a [ContainerClass]
  ///
  /// * [value]: A [ValueClass]
  ContainerClass({this.value});

  @override
  List<Object?> get props => [value];

  /// Creates a [ContainerClass] from json map
  factory ContainerClass.fromJson(Map<String, dynamic> json) => ContainerClass(
      value: ValueClass.fromJson(json['value'] as Map<String, dynamic>));

  /// Creates a json map from a [ContainerClass]
  Map<String, dynamic> toJson() => <String, dynamic>{'value': value?.toJson()};
}

/// A [ValueClass] implementation of a [ValueGenerator] which produces a [ValueClass] from a provided seed
class ContainerClassGenerator extends ValueGenerator {
  /// The generator used for the [ContainerClass] value
  final ValueGenerator _ithGenerator;

  /// Builds a [ContainerClassGenerator] with a provided [ContainerClass.value] element generator, [_ithGenerator]
  ///
  /// * [_ithGenerator]: The [ContainerClass.value] generator
  ContainerClassGenerator(this._ithGenerator);

  @override
  dynamic nextValue(int seed) {
    return ContainerClass(value: _ithGenerator.nextValue(seed));
  }

  @override
  Function(Map<String, dynamic> json) get fromEncodable =>
      (Map<String, dynamic> json) => ContainerClass.fromJson(json);
}

abstract class EntryGenerator<I extends Info, E extends Entry<I>> {
  /// A value generator
  ValueGenerator get generator;

  /// Creates a new [Entry] with the provided [ValueGenerator] and [seed]
  ///
  /// * [seed]: The seed for the [ValueGenerator]
  /// * [key]: The entry key
  /// * [creationTime]: The entry creation time
  ///
  /// Returns a fully initialized [Entry]
  E newEntry(int seed, {String? key, DateTime? creationTime});
}

/// Base class for all the test contexts.
abstract class TestContext<I extends Info, E extends Entry<I>,
    T extends Store<I, E>> implements EntryGenerator<I, E> {
  @override
  final ValueGenerator generator;

  /// Builds a new [TestContext]
  ///
  /// * [generator]: A value generator
  TestContext(this.generator);

  /// Creates a new store
  Future<T> newStore();

  /// Deletes a store
  ///
  /// * [store]: The [Store]
  Future<void> deleteStore(T store) {
    return store.deleteAll();
  }
}

/// Base class for all the vault test contexts.
abstract class VaultTestContext<T extends Store<VaultInfo, VaultEntry>>
    extends TestContext<VaultInfo, VaultEntry, T> {
  /// Builds a new [VaultTestContext]
  ///
  /// * [generator]: A value generator
  VaultTestContext(super.generator);

  /// Creates a new vault
  ///
  /// * [store]: The [Store]
  /// * [name]: The name of the vault
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [vaultLoader]: The [VaultLoader], that should be used to fetch a new value upon absence
  /// * [clock]: The source of time to be used on this
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Future<Vault<V>> newVault<V>(T store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      VaultLoader<V>? vaultLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats}) {
    return newGenericVault<V, T>(store,
        name: name,
        fromEncodable: fromEncodable ?? generator.fromEncodable,
        vaultLoader: vaultLoader,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

  /// Creates a new [VaultEntry] with the provided [ValueGenerator] and [seed]
  ///
  /// * [seed]: The seed for the [ValueGenerator]
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  ///
  /// Returns a fully initialized [VaultEntry]
  @override
  VaultEntry newEntry(int seed, {String? key, DateTime? creationTime}) {
    return VaultEntryBuilder(key ?? 'vault_key_$seed',
            generator.nextValue(seed), creationTime ?? DateTime.now())
        .build();
  }
}

/// Base class for all the cache test contexts.
abstract class CacheTestContext<T extends Store<CacheInfo, CacheEntry>>
    extends TestContext<CacheInfo, CacheEntry, T> {
  /// Builds a new [CacheTestContext]
  ///
  /// * [generator]: A value generator
  CacheTestContext(super.generator);

  /// Creates a new cache
  ///
  /// * [store]: The [Store]
  /// * [name]: The name of the cache
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [expiryPolicy]: The expiry policy to use
  /// * [sampler]: The sampler to use upon eviction of a cache element
  /// * [evictionPolicy]: The eviction policy to use
  /// * [maxEntries]: The max number of entries this cache can hold if provided.
  /// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon absence or expiration
  /// * [clock]: The source of time to be used on this
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  Future<Cache<V>> newCache<V>(T store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<V>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    return newGenericCache<V, T>(store,
        name: name,
        fromEncodable: fromEncodable ?? generator.fromEncodable,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
  }

  /// Creates a new [CacheEntry] with the provided [ValueGenerator] and [seed]
  ///
  /// * [seed]: The seed for the [ValueGenerator]
  /// * [key]: The cache key
  /// * [expiryDuration]: The cache expiry duration
  /// * [creationTime]: The cache creation time
  ///
  /// Returns a fully initialized [CacheEntry]
  @override
  CacheEntry newEntry(int seed,
      {String? key, Duration? expiryDuration, DateTime? creationTime}) {
    return CacheEntryBuilder(
      key ?? 'cache_key_$seed',
      generator.nextValue(seed),
      creationTime ?? DateTime.now(),
      expiryDuration ?? seed.minutes,
    ).build();
  }
}
