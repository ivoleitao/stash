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
  StringGenerator({String prefix}) : _prefix = prefix ?? 'String';

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
  IteratorGenerator(this._ithGenerator) : assert(_ithGenerator != null);

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
  MapGenerator(this._keyIthGenerator, this._valueIthGenerator)
      : assert(_keyIthGenerator != null),
        assert(_valueIthGenerator != null);

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
  SampleClassGenerator(this._ithGenerator) : assert(_ithGenerator != null);

  @override
  dynamic nextValue(int idx) {
    return SampleClass(value: _ithGenerator.nextValue(idx));
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
    {String key,
    DateTime expiryTime,
    DateTime creationTime,
    DateTime accessTime,
    DateTime updateTime,
    int hitCount}) {
  return CacheEntry(key ?? 'cache_key_${seed}', generator.nextValue(seed),
      expiryTime ?? seed.minutes.fromNow,
      creationTime: creationTime,
      accessTime: accessTime,
      updateTime: updateTime,
      hitCount: hitCount);
}
