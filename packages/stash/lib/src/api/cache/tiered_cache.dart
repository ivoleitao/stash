import 'package:async/async.dart';
import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/event/event.dart';

/// Tiered implementation of the [Cache] interface allowing the assignement
/// of a primary and secondary caches. It was designed to be used with a primary
/// [Cache] bound to a fast [CacheStore] and a secondary
/// cache bound to a persistent [CacheStore] implementation
class TieredCache extends Cache {
  /// The primary cache
  final Cache _primary;

  /// The secondary cache
  final Cache _secondary;

  /// Builds a [TieredCache] with a primary and a secondary cache
  ///
  /// * [_primary]: The primary [Cache]
  /// * [_secondary]: The secondary [Cache]
  ///
  /// Returns a [TieredCache]
  TieredCache(this._primary, this._secondary);

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
  Future<dynamic?> get(String key, {Duration? expiryDuration}) {
    return _primary.get(key, expiryDuration: expiryDuration).then((value) =>
        value != null
            ? Future.value(value)
            : _secondary.get(key, expiryDuration: expiryDuration));
  }

  @override
  Future<void> put(String key, dynamic value, {Duration? expiryDuration}) {
    _secondary.put(key, value, expiryDuration: expiryDuration);
    return _primary.put(key, value, expiryDuration: expiryDuration);
  }

  @override
  Future<dynamic> operator [](String key) {
    return _primary[key]
        .then((value) => value != null ? Future.value(value) : _secondary[key]);
  }

  @override
  Future<bool> putIfAbsent(String key, dynamic value,
      {Duration? expiryDuration}) {
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
  Future<dynamic?> getAndPut(String key, dynamic value,
      {Duration? expiryDuration}) {
    return _primary.getAndPut(key, value).then((value) {
      if (value == null) {
        return _secondary.getAndPut(key, value);
      }

      _secondary.put(key, value);

      return Future.value(value);
    });
  }

  @override
  Future<dynamic?> getAndRemove(String key) {
    return _primary.getAndRemove(key).then((value) {
      if (value == null) {
        return _secondary.getAndRemove(key);
      }

      return _secondary.remove(key).then((any) => value);
    });
  }

  @override
  Stream<T> on<T extends CacheEvent>() {
    return StreamGroup.merge([_primary.on<T>(), _secondary.on<T>()]);
  }
}
