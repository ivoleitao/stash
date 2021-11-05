import 'package:async/async.dart';
import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/event/event.dart';
import 'package:stash/src/api/cache/stats/default_stats.dart';
import 'package:uuid/uuid.dart';

import 'cache_manager.dart';
import 'cache_stats.dart';

/// Tiered implementation of the [Cache] interface allowing the assignement
/// of a primary and secondary caches. It was designed to be used with a primary
/// [Cache] bound to a fast store and a secondary
/// cache bound to a persistent store implementation
class TieredCache<T> implements Cache<T> {
  /// The primary cache
  final Cache<T> _primary;

  /// The secondary cache
  final Cache<T> _secondary;

  @override
  final CacheManager? manager;

  @override
  final String name;

  /// The source of time to be used on this cache
  final Clock clock;

  @override
  final bool statsEnabled;

  @override
  final CacheStats stats;

  /// Builds a [TieredCache] with a primary and a secondary cache
  ///
  /// * [_primary]: The primary [Cache]
  /// * [_secondary]: The secondary [Cache]
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance, defaults to [DefaultCacheStats]
  ///
  /// Returns a [TieredCache]
  TieredCache(this._primary, this._secondary,
      {this.manager,
      String? name,
      Clock? clock,
      bool? statsEnabled,
      CacheStats? stats})
      : name = name ?? Uuid().v1(),
        clock = clock ?? Clock(),
        statsEnabled = statsEnabled ?? false,
        stats = stats ?? DefaultCacheStats();

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
    // #region Statistics
    Stopwatch? watch;
    Future<T?> Function(T? value) posGet = (T? value) => Future.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (T? value) {
        if (watch != null) {
          stats.increaseGets();
          stats.addGetTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future.value(value);
      };
    }
    // #endregion

    return _primary
        .get(key, expiryDuration: expiryDuration)
        .then((T? value) => value != null
            ? Future.value(value)
            : _secondary.get(key, expiryDuration: expiryDuration))
        .then(posGet);
  }

  @override
  Future<void> put(String key, T value, {Duration? expiryDuration}) {
    // #region Statistics
    Stopwatch? watch;
    Future<void> Function(void) posPut = (_) => Future<void>.value();
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posPut = (_) {
        stats.increasePuts();
        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion

    return _secondary
        .put(key, value, expiryDuration: expiryDuration)
        .then((_) => _primary.put(key, value, expiryDuration: expiryDuration))
        .then(posPut);
  }

  @override
  Future<T?> operator [](String key) {
    return _primary[key]
        .then((value) => value != null ? Future.value(value) : _secondary[key]);
  }

  @override
  Future<bool> putIfAbsent(String key, T value, {Duration? expiryDuration}) {
    // #region Statistics
    Stopwatch? watch;
    Future<bool> Function(bool ok) posPut = (bool ok) => Future<bool>.value(ok);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posPut = (bool ok) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<bool>.value(ok);
      };
    }
    // #endregion

    return _secondary
        .putIfAbsent(key, value, expiryDuration: expiryDuration)
        .then((_) =>
            _primary.putIfAbsent(key, value, expiryDuration: expiryDuration))
        .then(posPut);
  }

  @override
  Future<void> clear() {
    return _primary.clear().then((any) => _secondary.clear());
  }

  @override
  Future<void> remove(String key) {
    // #region Statistics
    Stopwatch? watch;
    Future<void> Function(dynamic) posRemove = (_) => Future<void>.value();
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posRemove = (_) {
        stats.increaseRemovals();
        if (watch != null) {
          stats.addRemoveTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion
    return _primary
        .remove(key)
        .then((_) => _secondary.remove(key))
        .then(posRemove);
  }

  @override
  Future<T?> getAndPut(String key, T value, {Duration? expiryDuration}) {
    // #region Statistics
    Stopwatch? watch;
    Future<T?> Function(T? value) posGetPut = (T? value) => Future.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGetPut = (T? value) {
        if (value == null) {
          stats.increaseMisses();
        } else {
          stats.increaseGets();
        }
        stats.increasePuts();
        if (watch != null) {
          int elapsed = watch.elapsedMicroseconds;
          stats.addGetTime(elapsed);
          stats.addPutTime(elapsed);
          watch.stop();
        }

        return Future.value(value);
      };
    }
    // #endregion

    return _primary.getAndPut(key, value).then((primaryValue) {
      if (primaryValue == null) {
        return _secondary.getAndPut(key, value);
      }

      return _secondary.put(key, value).then((_) => value);
    }).then(posGetPut);
  }

  @override
  Future<T?> getAndRemove(String key) {
    // #region Statistics
    Stopwatch? watch;
    Future<T?> Function(T? value) posGetRemove =
        (T? value) => Future.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGetRemove = (T? value) {
        if (value == null) {
          stats.increaseMisses();
        } else {
          stats.increaseGets();
        }
        stats.increaseRemovals();
        if (watch != null) {
          int elapsed = watch.elapsedMicroseconds;
          stats.addGetTime(elapsed);
          stats.addRemoveTime(elapsed);
          watch.stop();
        }

        return Future.value(value);
      };
    }
    // #endregion

    return _primary.getAndRemove(key).then((value) {
      if (value == null) {
        return _secondary.getAndRemove(key);
      }

      return _secondary.remove(key).then((_) => value);
    }).then(posGetRemove);
  }

  @override
  Stream<E> on<E extends CacheEvent<T>>() {
    return StreamGroup.merge([_primary.on<E>(), _secondary.on<E>()]);
  }
}
