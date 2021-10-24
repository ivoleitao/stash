import 'dart:async';

import 'package:clock/clock.dart';
import 'package:stash/src/api/cache/cache.dart';
import 'package:stash/src/api/cache/cache_entry.dart';
import 'package:stash/src/api/cache/cache_info.dart';
import 'package:stash/src/api/cache/cache_stats.dart';
import 'package:stash/src/api/cache/event/created_event.dart';
import 'package:stash/src/api/cache/event/event.dart';
import 'package:stash/src/api/cache/event/evicted_event.dart';
import 'package:stash/src/api/cache/event/expired_event.dart';
import 'package:stash/src/api/cache/event/removed_event.dart';
import 'package:stash/src/api/cache/event/updated_event.dart';
import 'package:stash/src/api/cache/eviction/eviction_policy.dart';
import 'package:stash/src/api/cache/eviction/lfu_policy.dart';
import 'package:stash/src/api/cache/expiry/eternal_policy.dart';
import 'package:stash/src/api/cache/expiry/expiry_policy.dart';
import 'package:stash/src/api/cache/sampler/full_sampler.dart';
import 'package:stash/src/api/cache/sampler/sampler.dart';
import 'package:stash/src/api/cache/stats/default_stats.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:uuid/uuid.dart';

import 'cache_manager.dart';

/// Default implementation of the [Cache] interface
class DefaultCache<T> implements Cache<T> {
  /// The name of this cache
  @override
  final String name;

  @override
  final CacheManager? manager;

  /// The [Store] for this cache
  final Store<CacheInfo, CacheEntry> storage;

  /// The [ExpiryPolicy] for this cache
  final ExpiryPolicy expiryPolicy;

  /// The [KeySampler] used this cache upon eviction
  final KeySampler sampler;

  /// The [EvictionPolicy] used by this cache
  final EvictionPolicy evictionPolicy;

  /// The maximum number of entries supported by this cache
  final int maxEntries;

  /// The [CacheLoader] for this cache. When set is used
  /// when the cache is expired to fetch a new value
  final CacheLoader<T> cacheLoader;

  /// The source of time to be used on this cache
  final Clock clock;

  /// The [StreamController] for this cache events
  final StreamController streamController;

  /// The event publishing mode of this cache
  final EventListenerMode eventPublishingMode;

  @override
  final bool statsEnabled;

  @override
  final CacheStats stats;

  /// Builds a [DefaultCache] out of a mandatory [Store] and a set of optional configurations
  ///
  /// * [storage]: The [Store]
  /// * [manager]: An optional [CacheManager]
  /// * [name]: The name of the cache
  /// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
  /// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
  /// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon expiration
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this cache
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance, defaults to [DefaultCacheStats]
  ///
  /// Returns a [DefaultCache]
  DefaultCache(this.storage,
      {this.manager,
      String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader<T>? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      CacheStats? stats})
      : name = name ?? Uuid().v1(),
        expiryPolicy = expiryPolicy ?? const EternalExpiryPolicy(),
        sampler = sampler ?? const FullSampler(),
        evictionPolicy = evictionPolicy ?? const LfuEvictionPolicy(),
        assert(maxEntries == null || maxEntries >= 0),
        maxEntries = maxEntries ?? 0,
        cacheLoader = cacheLoader ?? ((key) => Future.value()),
        clock = clock ?? Clock(),
        eventPublishingMode = eventListenerMode ?? EventListenerMode.disabled,
        streamController = StreamController.broadcast(
            sync: eventListenerMode == EventListenerMode.synchronous),
        statsEnabled = statsEnabled ?? false,
        stats = stats ?? DefaultCacheStats();

  /// Fires a new event on the event bus with the specified [event].
  void _fire(CacheEvent<T>? event) {
    if (eventPublishingMode != EventListenerMode.disabled && event != null) {
      streamController.add(event);
    }
  }

  @override
  Stream<E> on<E extends CacheEvent<T>>() {
    if (E == dynamic) {
      return streamController.stream as Stream<E>;
    } else {
      return streamController.stream.where((event) => event is E).cast<E>();
    }
  }

  /// Gets the cache storage size
  ///
  /// Returns the cache size
  Future<int> _getStorageSize() {
    return storage.size(name);
  }

  /// Gets a cache entry from storage
  ///
  /// * [key]: the cache key to retrieve from the underlining storage
  ///
  /// Returns the cache entry
  Future<CacheEntry?> _getStorageEntry(String key) {
    return storage.getEntry(name, key);
  }

  /// Method used to check if the configured capacity of this cache i.e. was
  /// exceeded after the inserting [entry]
  ///
  /// * [entry]: The added entry
  Future<bool> _isCapacityExceeded(CacheEntry entry) => maxEntries == 0
      ? Future.value(false)
      : size.then((entries) => entries > maxEntries);

  /// Puts a cache entry identified by [key] on the configured [Store]
  ///
  /// * [key]: The cache key
  /// * [entry]: The cache entry
  /// * [event]: An optional event
  Future<void> _putStorageEntry(String key, CacheEntry entry,
      {CacheEvent<T>? event}) {
    if (entry.valueChanged) {
      // #region Statistics
      Future<void> Function(dynamic) posEvict = (_) => Future<void>.value();
      if (statsEnabled) {
        posEvict = (_) {
          stats.increaseEvictions();

          return Future<void>.value();
        };
      }
      // #endregion

      return storage
          .putEntry(name, key, entry)
          .then((_) => _fire(event))
          .then((_) => _isCapacityExceeded(entry))
          .then((capacityExceeded) {
        if (capacityExceeded) {
          return storage.keys(name).then(
              (ks) => storage.getInfos(name, sampler.sample(ks)).then((infos) {
                    final info = evictionPolicy.select(infos, entry.info);
                    if (info != null) {
                      return _removeEntryByKey(info.key, evicted: true)
                          .then(posEvict);
                    }

                    return Future<void>.value();
                  }));
        }

        return Future<void>.value();
      });
    } else {
      return storage.setInfo(name, key, entry.info);
    }
  }

  /// Removes the stored [CacheEntry] for the specified [key].
  ///
  /// * [key]: The cache key
  /// * [event]: The event
  Future<void> _removeStorageEntry(String key, CacheEvent<T> event) {
    return storage.remove(name, key).then((_) => _fire(event));
  }

  /// Clear the cache storage
  Future<void> _clearStorage() {
    return storage.clear(name);
  }

  @override
  Future<int> get size {
    return _getStorageSize();
  }

  @override
  Future<Iterable<String>> get keys => storage.keys(name);

  @override
  Future<bool> containsKey(String key) {
    // Current time
    final now = clock.now();

    return _getStorageEntry(key).then((entry) {
      return entry != null && !entry.isExpired(now);
    });
  }

  /// Puts the value in the cache.
  ///
  /// * [key]: the cache key
  /// * [value]: the cache value
  /// * [now]: the current date/time
  /// * [expiryDuration]: how much time for this cache to expire.
  Future<bool> _putEntry(
      String key, T value, DateTime now, Duration? expiryDuration) {
    // How much time till the expiration of this cache entry
    final duration = expiryDuration ?? expiryPolicy.getExpiryForCreation();
    // We want to create a new entry, let's update it according with the semantics
    // of the configured expiry policy and store it
    final expiryTime = now.add(duration);
    final entry = CacheEntry.newEntry(key, now, expiryTime, value);

    // Check if the entry is expired before adding it to the cache
    if (!entry.isExpired(now)) {
      // Nope, it's not expired let's store it then and return
      return _putStorageEntry(key, entry,
              event: CacheEntryCreatedEvent<T>(this, entry))
          .then((_) => true);
    }

    return Future.value(false);
  }

  /// Returns the cache entry value updating the cache info i.e. updates
  /// [CacheEntry.accessTime] with the access time, increments [CacheEntry.hitcount]
  /// and sets [CacheEntry.expiryTime] according with the configured [ExpiryPolicy]
  /// in place for this cache entry or with the [expiryDuration] parameter
  ///
  /// * [entry]: the [CacheEntry] holding the value
  /// * [now]: the current date/time
  Future<T?> _getEntryValue(
      CacheEntry entry, DateTime now, Duration? expiryDuration) {
    entry.accessTime = now;
    entry.hitCount++;
    final duration = expiryPolicy.getExpiryForAccess();
    if (duration != null) {
      // We just need to update the expiry time on the entry
      // according with the expiry policy in place or if provided the expiry duration
      entry.expiryTime = now.add(expiryDuration ?? duration);
    }

    // Store the entry changes and return the value
    return _putStorageEntry(entry.key, entry).then((_) => entry.value);
  }

  /// Updates the entry value and the cache info: the
  /// [CacheEntry.updateTime] with the update time, increments [CacheEntry.hitcount]
  /// and the [CacheEntry.expiryTime] according with [ExpiryPolicy]
  /// in place for this cache entry
  ///
  /// * [entry]: the [CacheEntry] holding the value
  /// * [value]: the new value
  /// * [now]: the current date/time
  /// * [expiryDuration]: how much time for this cache entry to expire.
  Future<T> _updateEntry(
      CacheEntry entry, T value, DateTime now, Duration? expiryDuration) {
    final duration = expiryPolicy.getExpiryForUpdate();
    // We just need to update the expiry time on the entry
    // according with the expiry policy in place or if provided the expiry duration
    final newEntry = entry.updateEntry(value,
        expiryTime:
            duration != null ? now.add(expiryDuration ?? duration) : null,
        updateTime: now,
        hitCount: entry.hitCount + 1);

    // Finally store the entry in the underlining storage
    return _putStorageEntry(entry.key, newEntry,
            event: CacheEntryUpdatedEvent<T>(this, entry, newEntry))
        .then((_) => entry.value);
  }

  @override
  Future<T?> get(String key, {Duration? expiryDuration}) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<CacheEntry?> Function(CacheEntry? entry) posGet1 =
        (CacheEntry? entry) => Future.value(entry);
    Future<T?> Function(T? value) posGet2 = (T? value) => Future.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet1 = (CacheEntry? entry) {
        if (entry == null || entry.isExpired(now)) {
          stats.increaseMisses();
          if (entry != null) {
            stats.increaseExpiries();
          }
        } else {
          stats.increaseGets();
        }

        return Future.value(entry);
      };
      posGet2 = (T? value) {
        if (watch != null) {
          stats.addGetTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future.value(value);
      };
    }
    // #endregion

    // Gets the entry from the storage
    return _getStorageEntry(key).then(posGet1).then((entry) {
      final expired = entry != null && entry.isExpired(now);
      // Does this entry exists or is expired ?
      if (entry == null || expired) {
        // If expired we need to remove the value from the storage
        final pre = expired
            ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, entry!))
            : Future<void>.value();

        // Invoke the cache loader
        return pre.then((_) => cacheLoader(key)).then((value) {
          // If the value obtained is `null` just return it
          if (value == null) {
            return Future<T?>.value();
          }

          return _putEntry(key, value, now, expiryDuration)
              .then((_) => posGet2(value));
        });
      } else {
        return _getEntryValue(entry, now, expiryDuration).then(posGet2);
      }
    });
  }

  @override
  Future<void> put(String key, T value, {Duration? expiryDuration}) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<void> Function(bool) posPut = (_) => Future<void>.value();
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posPut = (bool ok) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion

    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final expired = entry != null && entry.isExpired(now);
      // If the entry does not exist or is expired
      if (entry == null || expired) {
        // If expired we remove it
        final prePut = expired
            ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, entry!))
            : Future<void>.value();

        // And finally we add it to the cache
        return prePut
            .then((_) => _putEntry(key, value, now, expiryDuration))
            .then(posPut);
      } else {
        // Already present let's update the cache instead
        return _updateEntry(entry, value, now, expiryDuration)
            .then((_) => posPut(true));
      }
    });
  }

  @override
  Future<T?> operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, T value, {Duration? expiryDuration}) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<CacheEntry?> Function(CacheEntry? entry) posGet =
        (CacheEntry? entry) => Future.value(entry);
    Future<bool> Function(bool ok) posPut = (bool ok) => Future<bool>.value(ok);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (CacheEntry? entry) {
        if (entry == null || entry.isExpired(now)) {
          stats.increaseMisses();
        } else {
          stats.increaseGets();
        }

        return Future.value(entry);
      };
      posPut = (bool ok) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future<bool>.value(ok);
      };
    }
    // #endregion

    // Try to get the entry from the cache
    return _getStorageEntry(key).then(posGet).then((entry) {
      final expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      final pre = expired
          ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, entry!))
          : Future<void>.value();

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return pre
            .then((_) => _putEntry(key, value, now, expiryDuration))
            .then(posPut);
      }

      return posPut(false);
    });
  }

  @override
  Future<void> clear() {
    return _clearStorage();
  }

  /// Removes a entry from storage by [key]
  ///
  /// * [key]: key whose mapping is to be removed from the cache
  /// * [evicted]: If the reason for removal was eviction
  ///
  /// Returns true if the entry was removed, false otherwise
  Future<void> _removeEntryByKey(String key, {bool evicted = false}) {
    // Current time
    final now = clock.now();

    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        // The entry exists on cache
        // Let's check if it is expired
        if (entry.isExpired(now)) {
          // If expired let's remove from cache and send an expired event
          return _removeStorageEntry(
              key, CacheEntryExpiredEvent<T>(this, entry));
        } else {
          // If not expired let's remove and send and removed event
          return _removeStorageEntry(
              key,
              evicted
                  ? CacheEntryEvictedEvent<T>(this, entry)
                  : CacheEntryRemovedEvent<T>(this, entry));
        }
      }

      // Do nothing the entry does not exist
      return Future<void>.value();
    });
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
          stats.addRemoveTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion
    return _removeEntryByKey(key).then(posRemove);
  }

  @override
  Future<T?> getAndPut(String key, T value, {Duration? expiryDuration}) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<CacheEntry?> Function(CacheEntry? entry) posGet =
        (CacheEntry? entry) => Future.value(entry);
    Future<T?> Function(bool ok, T? value) posPut =
        (bool ok, T? value) => Future<T?>.value(value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (CacheEntry? entry) {
        if (entry == null || entry.isExpired(now)) {
          stats.increaseMisses();
          if (entry != null) {
            stats.increaseExpiries();
          }
        } else {
          stats.increaseGets();
        }
        if (watch != null) {
          stats.addGetTime(watch.elapsedMilliseconds);
        }

        return Future.value(entry);
      };
      posPut = (bool ok, T? value) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future<T?>.value();
      };
    }
    // #endregion

    // Try to get the entry from the cache
    return _getStorageEntry(key).then(posGet).then((entry) {
      final expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      final pre = expired
          ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, entry!))
          : Future.value();

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return pre.then((_) => _putEntry(key, value, now, expiryDuration)
            .then((bool ok) => posPut(ok, null)));
      } else {
        return pre
            .then((_) => _updateEntry(entry, value, now, expiryDuration))
            .then((value) => posPut(true, value));
      }
    });
  }

  @override
  Future<T?> getAndRemove(String key) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<CacheEntry?> Function(CacheEntry? entry) posGet =
        (CacheEntry? entry) => Future.value(entry);
    Future<T?> Function(CacheEntry entry) posRemove =
        (CacheEntry entry) => Future<T?>.value(entry.value);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (CacheEntry? entry) {
        if (entry == null || entry.isExpired(now)) {
          stats.increaseMisses();
          if (entry != null) {
            stats.increaseExpiries();
          }
        } else {
          stats.increaseGets();
        }
        if (watch != null) {
          stats.addGetTime(watch.elapsedMilliseconds);
        }

        return Future.value(entry);
      };
      posRemove = (CacheEntry entry) {
        stats.increaseRemovals();
        if (watch != null) {
          stats.addRemoveTime(watch.elapsedMilliseconds);
          watch.stop();
        }

        return Future<T?>.value(entry.value);
      };
    }
    // #endregion

    // Try to get the entry from the cache
    return _getStorageEntry(key).then(posGet).then((entry) {
      if (entry != null) {
        // The entry exists on cache
        // Let's check if it is expired
        if (entry.isExpired(now)) {
          // If expired let's remove from cache, send an expired event and return
          // null
          return _removeStorageEntry(
                  key, CacheEntryExpiredEvent<T>(this, entry))
              .then((_) => posRemove(entry));
        } else {
          // If not expired let's remove from cache, send a removed event and
          // return the value
          return _removeStorageEntry(
                  key, CacheEntryRemovedEvent<T>(this, entry))
              .then((_) => posRemove(entry));
        }
      }

      return Future<T?>.value();
    });
  }
}
