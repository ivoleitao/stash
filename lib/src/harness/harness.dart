import 'package:equatable/equatable.dart';
import 'package:quiver/time.dart';
import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache/default_cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';
import 'package:stash/src/api/expiry/expiry_policy.dart';
import 'package:stash/src/api/sampler/sampler.dart';
import 'package:time/time.dart';

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
Cache newDefaultCache<T extends CacheStore>(T store,
    {String? name,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    Clock? clock}) {
  return Cache.newCache(store,
      name: name,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader,
      clock: clock);
}

/// Generic definition of a value generator
abstract class ValueGenerator {
  /// Returns a new value out of a provided [seed]
  ///
  /// * [seed]: The seed used to generate a new value
  ///
  /// Returns a new value generated from the provided [seed]
  dynamic nextValue(int seed);
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
  dynamic nextValue(int idx) {
    return SampleClass(value: _ithGenerator.nextValue(idx));
  }
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
  Cache newCache(T store,
      {String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader? cacheLoader,
      Clock? clock}) {
    return newDefaultCache(store,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock);
  }

  /// Deletes a store
  ///
  /// * [store]: The [CacheStore]
  Future<void> deleteStore(T store) {
    return store.deleteAll();
  }

  /// Assert that [actual] matches [matcher].
  ///
  /// * [actual]: The current value
  /// * [matcher]: Can be a value in which case it will be wrapped in an equals matcher
  /// * [reason]: If provided it is appended to the reason generated by the matcher
  /// * [skip]: Is a String or `true`, the assertion is skipped. The arguments are still evaluated, but [actual] is not verified to match [matcher]
  void check(actual, matcher, {String reason, skip});
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
  return CacheEntry(key ?? 'cache_key_${seed}', generator.nextValue(seed),
      expiryTime ?? seed.minutes.fromNow, creationTime ?? DateTime.now(),
      accessTime: accessTime, updateTime: updateTime, hitCount: hitCount);
}
