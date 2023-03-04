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
import 'package:stash/src/api/entry.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:uuid/uuid.dart';

import 'cache_manager.dart';

/// Generic implementation of the [Cache] interface
class GenericCache<T> implements Cache<T> {
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
  final CacheLoader<T?> cacheLoader;

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

  /// Builds a [GenericCache] out of a mandatory [Store] and a set of optional configurations
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
  /// Returns a [GenericCache]
  GenericCache(this.storage,
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
        cacheLoader = cacheLoader ?? ((key) => Future<T?>.value()),
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

  /// Gets a cache info from storage
  ///
  /// * [key]: the cache key to retrieve from the underlining storage
  ///
  /// Returns the cache info
  Future<CacheInfo?> _getStorageInfo(String key) {
    return storage.getInfo(name, key);
  }

  /// Gets a cache entry from storage
  ///
  /// * [key]: the cache key to retrieve from the underlining storage
  ///
  /// Returns the cache entry
  Future<CacheEntry?> _getStorageEntry(String key) {
    return storage.getEntry(name, key);
  }

  /// Puts a cache entry identified by [key] on the configured [Store]
  ///
  /// * [key]: The cache key
  /// * [entry]: The cache entry
  /// * [now]: The current date/time
  /// * [event]: An optional event
  Future<void> _putStorageEntry(String key, CacheEntry entry, DateTime now,
      {CacheEvent<T>? event}) {
    if (entry.state == EntryState.added || entry.state == EntryState.updated) {
      var prePut = () => Future<void>.value();
      if (entry.state == EntryState.added && maxEntries > 0) {
        // There's a number of max entries configured
        prePut = () => storage.size(name).then((currentSize) {
              if ((currentSize + 1) > maxEntries) {
                return storage.keys(name).then((ks) =>
                    storage.getInfos(name, sampler.sample(ks)).then((infos) {
                      final info = evictionPolicy.select(infos, now);
                      if (info != null) {
                        return _removeEntryByKey(info.key, now, evicted: true);
                      }

                      return Future<void>.value();
                    }));
              }

              return Future<void>.value();
            });
      }

      return prePut()
          .then((value) => storage.putEntry(name, key, entry))
          .then((_) => _fire(event));
    } else if (entry.state == EntryState.updatedInfo) {
      return storage.setInfo(name, key, entry.info);
    }

    return Future<void>.value();
  }

  /// Removes the stored [CacheEntry] for the specified [key].
  ///
  /// * [key]: The cache key
  /// * [event]: The event
  Future<void> _removeStorageEntry(String key, CacheEvent<T> event) {
    return storage.remove(name, key).then((_) {
      _fire(event);
      // #region Statistics
      if (statsEnabled) {
        if (event.type == CacheEventType.expired) {
          stats.increaseExpiries();
        } else if (event.type == CacheEventType.evicted) {
          stats.increaseEvictions();
        }
      }
      // #endregion
    });
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
  /// * [builder]: the entry builder
  Future<bool> _newEntry(CacheEntryBuilder<T> builder) {
    final entry = builder.build();

    // Check if the entry is expired before adding it to the cache
    if (!entry.isExpired(entry.creationTime)) {
      // Nope, it's not expired let's store it then and return
      return _putStorageEntry(entry.key, entry, entry.creationTime,
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
  Future<T?> _getEntryValue(CacheEntry entry, DateTime now) {
    final duration = expiryPolicy.getExpiryForAccess();

    // We just need to update the expiry time on the entry
    // according with the expiry policy in place or if provided the expiry duration
    entry.updateInfoFields(
        expiryTime: duration != null ? now.add(duration) : null,
        accessTime: now,
        hitCount: entry.hitCount + 1);

    // Store the entry changes and return the value
    return _putStorageEntry(entry.key, entry, now).then((_) => entry.value);
  }

  /// Replaces the entry value and updates cache info:
  ///
  /// * Updates [CacheEntry.updateTime] with the current time
  /// * Increments [CacheEntry.hitcount]
  /// * Updates [CacheEntry.expiryTime] according with [ExpiryPolicy] in place for this cache entry
  ///
  /// * [info]: the [CacheInfo]
  /// * [value]: the new value
  /// * [now]: the current date/time
  Future<void> _replaceEntry(CacheInfo info, T value, DateTime now) {
    final duration = expiryPolicy.getExpiryForUpdate();
    // We just need to update the expiry time on the entry
    // according with the expiry policy in place or if provided the expiry duration
    final expiryTime = duration != null ? now.add(duration) : null;
    final hitCount = info.hitCount + 1;

    final newEntry =
        CacheEntry.updated(info, value, now, hitCount, expiryTime: expiryTime);

    // Finally store the entry in the underlining storage
    return _putStorageEntry(info.key, newEntry, now,
        event: CacheEntryUpdatedEvent<T>(this, info, newEntry));
  }

  /// Provides a new builder
  ///
  /// * [key]: the cache key
  /// * [value]: the cache value
  /// * [now]: the current date/time
  /// * [delegate]: Allows the caller to change entry values
  CacheEntryBuilder<T> _entryBuilder(String key, T value, DateTime now,
      {CacheEntryDelegate<T>? delegate}) {
    delegate ??= (CacheEntryBuilder<T> delegate) => delegate;

    return delegate(CacheEntryBuilder(
        key, value, now, expiryPolicy.getExpiryForCreation()));
  }

  @override
  Future<T?> get(String key, {CacheEntryDelegate<T>? delegate}) {
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
        } else {
          stats.increaseGets();
        }

        return Future.value(entry);
      };
      posGet2 = (T? value) {
        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
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
            ? _removeStorageEntry(
                key, CacheEntryExpiredEvent<T>(this, entry.info))
            : Future<void>.value();

        // Invoke the cache loader
        return pre.then((_) => cacheLoader(key)).then((value) {
          // If the value obtained is `null` just return it
          if (value == null) {
            return Future<T?>.value();
          }

          return _newEntry(_entryBuilder(key, value, now, delegate: delegate))
              .then((_) => value);
        }).then(posGet2);
      } else {
        return _getEntryValue(entry, now).then(posGet2);
      }
    });
  }

  @override
  Future<void> put(String key, T value, {CacheEntryDelegate<T>? delegate}) {
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
          stats.addPutTime(watch.elapsedMicroseconds);
          watch.stop();
        }

        return Future<void>.value();
      };
    }
    // #endregion

    // Try to get the entry from the cache
    return _getStorageInfo(key).then((info) {
      final expired = info != null && info.isExpired(now);
      // If the entry does not exist or is expired
      if (info == null || expired) {
        // If expired we remove it
        final prePut = expired
            ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, info))
            : Future<void>.value();

        // And finally we add it to the cache
        return prePut
            .then((_) =>
                _newEntry(_entryBuilder(key, value, now, delegate: delegate)))
            .then(posPut);
      } else {
        // Already present let's update the cache instead
        return _replaceEntry(info, value, now).then((_) => posPut(true));
      }
    });
  }

  @override
  Future<T?> operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, T value,
      {CacheEntryDelegate<T>? delegate}) {
    // Current time
    final now = clock.now();
    // #region Statistics
    Stopwatch? watch;
    Future<CacheInfo?> Function(CacheInfo? info) posGet =
        (CacheInfo? info) => Future.value(info);
    Future<bool> Function(bool ok) posPut = (bool ok) => Future<bool>.value(ok);
    if (statsEnabled) {
      watch = clock.stopwatch()..start();
      posGet = (CacheInfo? info) {
        if (info == null || info.isExpired(now)) {
          stats.increaseMisses();
        } else {
          stats.increaseGets();
        }

        return Future.value(info);
      };
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

    // Try to get the entry from the cache
    return _getStorageInfo(key).then(posGet).then((info) {
      final expired = info != null && info.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      final pre = expired
          ? _removeStorageEntry(key, CacheEntryExpiredEvent<T>(this, info))
          : Future<void>.value();

      // If the entry is expired or non existent
      if (info == null || expired) {
        return pre
            .then((_) =>
                _newEntry(_entryBuilder(key, value, now, delegate: delegate)))
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
  /// * [now]: the current date/time
  /// * [evicted]: If the reason for removal was eviction
  ///
  /// Returns true if the entry was removed, false otherwise
  Future<void> _removeEntryByKey(String key, DateTime now,
      {bool evicted = false}) {
    // Try to get the entry from the cache
    return _getStorageInfo(key).then((info) {
      if (info != null) {
        // The entry exists on cache
        // Let's check if it is expired
        if (info.isExpired(now)) {
          // If expired let's remove from cache and send an expired event
          return _removeStorageEntry(
              key, CacheEntryExpiredEvent<T>(this, info));
        } else {
          // If not expired let's remove and send and removed event
          return _removeStorageEntry(
              key,
              evicted
                  ? CacheEntryEvictedEvent<T>(this, info)
                  : CacheEntryRemovedEvent<T>(this, info));
        }
      }

      // Do nothing the entry does not exist
      return Future<void>.value();
    });
  }

  @override
  Future<void> remove(String key) {
    // Current time
    final now = clock.now();
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
    return _removeEntryByKey(key, now).then(posRemove);
  }

  @override
  Future<T?> getAndPut(String key, T value, {CacheEntryDelegate<T>? delegate}) {
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
        } else {
          stats.increaseGets();
        }
        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
        }

        return Future.value(entry);
      };
      posPut = (bool ok, T? value) {
        if (ok) {
          stats.increasePuts();
        }
        if (watch != null) {
          stats.addPutTime(watch.elapsedMicroseconds);
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
          ? _removeStorageEntry(
              key, CacheEntryExpiredEvent<T>(this, entry.info))
          : Future.value();

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return pre.then((_) =>
            _newEntry(_entryBuilder(key, value, now, delegate: delegate))
                .then((bool ok) => posPut(ok, null)));
      } else {
        return pre
            .then((_) => _replaceEntry(entry.info, value, now))
            .then((_) => posPut(true, entry.value));
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
        } else {
          stats.increaseGets();
        }
        if (watch != null) {
          stats.addGetTime(watch.elapsedMicroseconds);
        }

        return Future.value(entry);
      };
      posRemove = (CacheEntry entry) {
        stats.increaseRemovals();
        if (watch != null) {
          stats.addRemoveTime(watch.elapsedMicroseconds);
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
                  key, CacheEntryExpiredEvent<T>(this, entry.info))
              .then((_) => posRemove(entry));
        } else {
          // If not expired let's remove from cache, send a removed event and
          // return the value
          return _removeStorageEntry(
                  key, CacheEntryRemovedEvent<T>(this, entry.info))
              .then((_) => posRemove(entry));
        }
      }

      return Future<T?>.value();
    });
  }
}
