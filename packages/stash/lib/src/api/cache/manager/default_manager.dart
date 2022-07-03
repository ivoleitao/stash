import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/cache_manager.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/generic_cache.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';

class DefaultCacheManager extends CacheManager {
  /// The list of caches
  final _caches = <String, Cache>{};

  @override
  Iterable<String> get names => _caches.keys;

  @override
  Future<Cache<T>> newGenericCache<T>(Store<CacheInfo, CacheEntry> store,
      {String? name,
      dynamic Function(Map<String, dynamic>)? fromEncodable,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<T>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    final cache = GenericCache<T>(store,
        manager: this,
        name: name,
        expiryPolicy: expiryPolicy,
        sampler: sampler,
        evictionPolicy: evictionPolicy,
        maxEntries: maxEntries,
        cacheLoader: cacheLoader,
        clock: clock,
        eventListenerMode: eventListenerMode,
        statsEnabled: statsEnabled,
        stats: stats);
    _caches[cache.name] = cache;

    return store
        .create(cache.name, fromEncodable: fromEncodable)
        .then((_) => cache);
  }

  @override
  TieredCache<T> newTieredCache<T>(Cache<T> primary, Cache<T> secondary,
      {String? name, Clock? clock, bool? statsEnabled, CacheStats? stats}) {
    final cache = TieredCache<T>(primary, secondary,
        manager: this,
        name: name,
        clock: clock,
        statsEnabled: statsEnabled,
        stats: stats);

    _caches[cache.name] = cache;

    return cache;
  }

  @override
  V? get<T, V extends Cache<T>>(String name) {
    return _caches[name] as V?;
  }

  @override
  void remove(String name) {
    _caches.remove(name);
  }
}
