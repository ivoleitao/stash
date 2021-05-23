import 'dart:async';

import 'package:clock/clock.dart';
import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/event/entry_event.dart';
import 'package:stash/src/api/event/event.dart';
import 'package:stash/src/api/event/evicted_entry_event.dart';
import 'package:stash/src/api/event/expired_entry_event.dart';
import 'package:stash/src/api/event/removed_entry_event.dart';
import 'package:stash/src/api/event/updated_entry_event.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';
import 'package:stash/src/api/eviction/lfu_policy.dart';
import 'package:stash/src/api/expiry/eternal_policy.dart';
import 'package:stash/src/api/expiry/expiry_policy.dart';
import 'package:stash/src/api/sampler/full_sampler.dart';
import 'package:stash/src/api/sampler/sampler.dart';
import 'package:stash/stash_api.dart';
import 'package:uuid/uuid.dart';

/// Default implementation of the [Cache] interface
class DefaultCache extends Cache {
  /// The name of this cache
  final String name;

  /// The [CacheStore] for this cache
  final CacheStore storage;

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
  final CacheLoader cacheLoader;

  /// The source of time to be used on this cache
  final Clock clock;

  /// The [StreamController] for this cache events
  final StreamController streamController;

  /// The event publishing mode of this cache
  final EventListenerMode eventPublishingMode;

  /// Builds a [DefaultCache] out of a mandatory [CacheStore] and a set of optional configurations
  ///
  /// * [storage]: The [CacheStore]
  /// * [name]: The name of the cache
  /// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
  /// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
  /// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
  /// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
  /// * [cacheLoader]: The [CacheLoader], that should be used to fetch a new value upon expiration
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [eventListenerMode]: The event listener mode of this cache
  ///
  /// Returns a [DefaultCache]
  DefaultCache(this.storage,
      {String? name,
      ExpiryPolicy? expiryPolicy,
      KeySampler? sampler,
      EvictionPolicy? evictionPolicy,
      int? maxEntries,
      CacheLoader? cacheLoader,
      Clock? clock,
      EventListenerMode? eventListenerMode})
      : name = name ?? Uuid().v1(),
        expiryPolicy = expiryPolicy ?? const EternalExpiryPolicy(),
        sampler = sampler ?? const FullSampler(),
        evictionPolicy = evictionPolicy ?? const LfuEvictionPolicy(),
        assert(maxEntries == null || maxEntries >= 0),
        maxEntries = maxEntries ?? 0,
        cacheLoader = cacheLoader ?? ((key) => Future.value()),
        clock = clock ?? Clock(),
        eventPublishingMode = eventListenerMode ?? EventListenerMode.Disabled,
        streamController = StreamController.broadcast(
            sync: eventListenerMode == EventListenerMode.Sync);

  /// Fires a new event on the event bus with the specified [event].
  void _fire(CacheEvent? event) {
    if (eventPublishingMode != EventListenerMode.Disabled && event != null) {
      streamController.add(event);
    }
  }

  @override
  Stream<T> on<T extends CacheEvent>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
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

  /// Puts a cache entry identified by [key] on the configured [CacheStore]
  ///
  /// * [key]: The cache key
  /// * [entry]: The cache entry
  /// * [event]: An optional event
  Future<void> _putStorageEntry(String key, CacheEntry entry,
      {CacheEntryEvent? event}) {
    if (entry.valueChanged) {
      return storage
          .putEntry(name, key, entry)
          .then((_) => _fire(event))
          .then((_) => _isCapacityExceeded(entry))
          .then((capacityExceeded) {
        if (capacityExceeded) {
          return storage.keys(name).then(
              (ks) => storage.getStats(name, sampler.sample(ks)).then((stats) {
                    final stat = evictionPolicy.select(stats, entry);
                    if (stat != null) {
                      return _removeEntryByKey(stat.key, evicted: true);
                    }

                    return Future.value();
                  }));
        }

        return Future.value();
      });
    } else {
      return storage.setStat(name, key, entry);
    }
  }

  /// Removes the stored [CacheEntry] for the specified [key].
  ///
  /// * [key]: The cache key
  /// * [event]: The event
  Future<void> _removeStorageEntry(String key, CacheEntryEvent event) {
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
    return _getStorageEntry(key).then((entry) {
      return entry != null && !entry.isExpired(clock.now());
    });
  }

  /// Puts the value in the cache.
  ///
  /// * [key]: the cache key
  /// * [value]: the cache value
  /// * [now]: the current date/time
  /// * [expiryDuration]: how much time for this cache to expire.
  Future<bool> _putEntry(
      String key, dynamic value, DateTime now, Duration? expiryDuration) {
    // How much time till the expiration of this cache entry
    final duration = expiryDuration ?? expiryPolicy.getExpiryForCreation();
    // We want to create a new entry, let's update it according with the semantics
    // of the configured expiry policy and store it
    final expiryTime = now.add(duration);
    final entry = CacheEntry(key, value, expiryTime, now);

    // Check if the entry is expired before adding it to the cache
    if (!entry.isExpired(now)) {
      // Nope, it's not expired let's store it then and return
      return _putStorageEntry(key, entry, event: CreatedEntryEvent(this, entry))
          .then((v) => true);
    }

    return Future.value(false);
  }

  /// Returns the cache entry value updating the cache statistics i.e. updates
  /// [CacheEntry.accessTime] with the access time, increments [CacheEntry.hitcount]
  /// and sets [CacheEntry.expiryTime] according with the configured [ExpiryPolicy]
  /// in place for this cache entry or with the [expiryDuration] parameter
  ///
  /// * [entry]: the [CacheEntry] holding the value
  /// * [now]: the current date/time
  Future<dynamic> _getEntryValue(
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
    return _putStorageEntry(entry.key, entry).then((v) => entry.value);
  }

  /// Updates the entry value and the cache statistics: the
  /// [CacheEntry.updateTime] with the update time, increments [CacheEntry.hitcount]
  /// and the [CacheEntry.expiryTime] according with [ExpiryPolicy]
  /// in place for this cache entry
  ///
  /// * [entry]: the [CacheEntry] holding the value
  /// * [value]: the new value
  /// * [now]: the current date/time
  /// * [expiryDuration]: how much time for this cache entry to expire.
  Future<dynamic> _updateEntry(
      CacheEntry entry, dynamic value, DateTime now, Duration? expiryDuration) {
    final duration = expiryPolicy.getExpiryForUpdate();
    // We just need to update the expiry time on the entry
    // according with the expiry policy in place or if provided the expiry duration
    final newEntry = entry.copyForUpdate(value,
        expiryTime:
            duration != null ? now.add(expiryDuration ?? duration) : null,
        updateTime: now,
        hitCount: entry.hitCount + 1);

    // Finally store the entry in the underlining storage
    return _putStorageEntry(entry.key, newEntry,
            event: UpdatedEntryEvent(this, entry, newEntry))
        .then((v) => entry.value);
  }

  @override
  Future<dynamic> get(String key, {Duration? expiryDuration}) {
    // Gets the entry from the storage
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      final expired = entry != null && entry.isExpired(now);
      // Does this entry exists or is expired ?
      if (entry == null || expired) {
        // If expired we need to remove the value from the storage
        final pre = expired
            ? _removeStorageEntry(key, ExpiredEntryEvent(this, entry!))
            : Future.value();

        // Invoke the cache loader
        return pre.then((_) => cacheLoader(key)).then((value) {
          // If the value obtained is `null` just return it
          if (value == null) {
            return null;
          }

          return _putEntry(key, value, now, expiryDuration).then((v) => value);
        });
      } else {
        return _getEntryValue(entry, now, expiryDuration);
      }
    });
  }

  @override
  Future<void> put(String key, dynamic value, {Duration? expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry does not exist or is expired
      if (entry == null || expired) {
        // If expired we remove it
        final pre = expired
            ? _removeStorageEntry(key, ExpiredEntryEvent(this, entry!))
            : Future.value();

        // And finally we add it to the cache
        return pre.then((_) => _putEntry(key, value, now, expiryDuration));
      } else {
        // Already present let's update the cache instead
        return _updateEntry(entry, value, now, expiryDuration);
      }
    });
  }

  @override
  Future<dynamic> operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, dynamic value,
      {Duration? expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      final pre = expired
          ? _removeStorageEntry(key, ExpiredEntryEvent(this, entry!))
          : Future.value();

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return pre.then((_) => _putEntry(key, value, now, expiryDuration));
      }

      return Future.value(false);
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
  Future<void> _removeEntryByKey(String key, {bool evicted = false}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        // The entry exists on cache
        // Let's check if it is expired
        if (entry.isExpired(clock.now())) {
          // If expired let's remove from cache and send an expired event
          return _removeStorageEntry(key, ExpiredEntryEvent(this, entry));
        } else {
          // If not expired let's remove and send and removed event
          return _removeStorageEntry(
              key,
              evicted
                  ? EvictedEntryEvent(this, entry)
                  : RemovedEntryEvent(this, entry));
        }
      }

      // Do nothing the entry does not exist
      return Future.value();
    });
  }

  @override
  Future<void> remove(String key) {
    return _removeEntryByKey(key);
  }

  @override
  Future<dynamic> getAndPut(String key, dynamic value,
      {Duration? expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      final pre = expired
          ? _removeStorageEntry(key, ExpiredEntryEvent(this, entry!))
          : Future.value();

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return pre.then((_) =>
            _putEntry(key, value, now, expiryDuration).then((v) => null));
      } else {
        return pre.then((_) => _updateEntry(entry, value, now, expiryDuration));
      }
    });
  }

  @override
  Future<dynamic> getAndRemove(String key) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        // The entry exists on cache
        // Let's check if it is expired
        if (entry.isExpired(clock.now())) {
          // If expired let's remove from cache, send an expired event and return
          // null
          return _removeStorageEntry(key, ExpiredEntryEvent(this, entry))
              .then((_) => null);
        } else {
          // If not expired let's remove from cache, send a removed event and
          // return the value
          return _removeStorageEntry(key, RemovedEntryEvent(this, entry))
              .then((value) => entry.value);
        }
      }

      return Future.value();
    });
  }
}
