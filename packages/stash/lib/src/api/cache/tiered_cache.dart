import 'package:async/async.dart';
import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/event/event.dart';
import 'package:uuid/uuid.dart';

import 'cache_manager.dart';

/// Tiered implementation of the [Cache] interface allowing the assignement
/// of a primary and secondary caches. It was designed to be used with a primary
/// [Cache] bound to a fast store and a secondary
/// cache bound to a persistent store implementation
class TieredCache<T> implements Cache<T> {
  /// The name of this cache
  @override
  final String name;

  @override
  final CacheManager? manager;

  /// The primary cache
  final Cache<T> _primary;

  /// The secondary cache
  final Cache<T> _secondary;

  /// Builds a [TieredCache] with a primary and a secondary cache
  ///
  /// * [_primary]: The primary [Cache]
  /// * [_secondary]: The secondary [Cache]
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  ///
  /// Returns a [TieredCache]
  TieredCache(this._primary, this._secondary, {this.manager, String? name})
      : name = name ?? Uuid().v1();

  /// Returns the set of discting keys across the [_primary] and [_secondary] caches configured
  Future<Iterable<String>> _distinctKeys() => _primary.keys.then((primaryKeys) {
        final keys = <String>{...primaryKeys};

        return _secondary.keys.then((secondaryKeys) {
          keys.addAll(secondaryKeys);

          return keys;
        });
      });

  @override
  Future<int> get size =>
      _distinctKeys().then((distinctKeys) => distinctKeys.length);

  @override
  Future<Iterable<String>> get keys => _distinctKeys();

  @override
  Future<bool> containsKey(String key) =>
      _primary.containsKey(key).then((contains) =>
          contains ? Future.value(true) : _secondary.containsKey(key));

  @override
  Future<T?> get(String key, {Duration? expiryDuration}) {
    return _primary.get(key, expiryDuration: expiryDuration).then((value) =>
        value != null
            ? Future.value(value)
            : _secondary.get(key, expiryDuration: expiryDuration));
  }

  @override
  Future<void> put(String key, T value, {Duration? expiryDuration}) {
    _secondary.put(key, value, expiryDuration: expiryDuration);
    return _primary.put(key, value, expiryDuration: expiryDuration);
  }

  @override
  Future<T?> operator [](String key) {
    return _primary[key]
        .then((value) => value != null ? Future.value(value) : _secondary[key]);
  }

  @override
  Future<bool> putIfAbsent(String key, T value, {Duration? expiryDuration}) {
    _secondary.putIfAbsent(key, value, expiryDuration: expiryDuration);
    return _primary.putIfAbsent(key, value, expiryDuration: expiryDuration);
  }

  @override
  Future<void> clear() {
    return _primary.clear().then((any) => _secondary.clear());
  }

  @override
  Future<void> remove(String key) {
    return _primary.remove(key).then((any) => _secondary.remove(key));
  }

  @override
  Future<T?> getAndPut(String key, T value, {Duration? expiryDuration}) {
    return _primary.getAndPut(key, value).then((primaryValue) {
      if (primaryValue == null) {
        return _secondary.getAndPut(key, value);
      }

      _secondary.put(key, value);

      return Future.value(value);
    });
  }

  @override
  Future<T?> getAndRemove(String key) {
    return _primary.getAndRemove(key).then((value) {
      if (value == null) {
        return _secondary.getAndRemove(key);
      }

      return _secondary.remove(key).then((any) => value);
    });
  }

  @override
  Stream<E> on<E extends CacheEvent<T>>() {
    return StreamGroup.merge([_primary.on<E>(), _secondary.on<E>()]);
  }
}
