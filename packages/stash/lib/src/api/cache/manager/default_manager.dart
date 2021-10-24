import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/cache_manager.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/default_cache.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';

class DefaultCacheManager implements CacheManager {
  /// The list of caches
  final _caches = <String, Cache>{};

  @override
  Iterable<String> get names => _caches.keys;

  @override
  Cache<T> newCache<T>(Store<CacheInfo, CacheEntry> storage,
      {CacheManager? manager,
      String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<T>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats}) {
    final cache = DefaultCache<T>(storage,
        manager: manager,
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

    return cache;
  }

  @override
  Cache<T> newTieredCache<T>(Cache<T> primary, Cache<T> secondary,
      {CacheManager? manager,
      String? name,
      Clock? clock,
      bool? statsEnabled,
      CacheStats? stats}) {
    final cache = TieredCache<T>(primary, secondary,
        manager: manager,
        name: name,
        clock: clock,
        statsEnabled: statsEnabled,
        stats: stats);

    _caches[cache.name] = cache;

    return cache;
  }

  @override
  Cache<T>? get<T>(String name) {
    return _caches[name] as Cache<T>?;
  }

  @override
  void remove(String name) {
    _caches.remove(name);
  }
}
