import 'package:quiver/time.dart';
import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';
import 'package:stash/src/api/eviction/lfu_policy.dart';
import 'package:stash/src/api/expiry/eternal_policy.dart';
import 'package:stash/src/api/expiry/expiry_policy.dart';
import 'package:stash/src/api/sampler/full_sampler.dart';
import 'package:stash/src/api/sampler/sampler.dart';
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
  ///
  /// Returns a [DefaultCache]
  DefaultCache(this.storage,
      {String name,
      ExpiryPolicy expiryPolicy,
      KeySampler sampler,
      EvictionPolicy evictionPolicy,
      int maxEntries,
      CacheLoader cacheLoader,
      Clock clock})
      : name = name ?? Uuid().v1(),
        expiryPolicy = expiryPolicy ?? const EternalExpiryPolicy(),
        sampler = sampler ?? const FullSampler(),
        evictionPolicy = evictionPolicy ?? const LfuEvictionPolicy(),
        assert(maxEntries == null || maxEntries >= 0),
        maxEntries = maxEntries ?? 0,
        cacheLoader = cacheLoader ?? ((key) => Future.value()),
        clock = clock ?? Clock();

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
  Future<CacheEntry> _getStorageEntry(String key) {
    return storage.getEntry(name, key);
  }

  /// Method used to check if the configured capacity of this cache i.e. was exceeded after the
  /// inserting [entry]
  ///
  /// * [entry]: The added entry
  Future<bool> _capacityExceeded(CacheEntry entry) => maxEntries == 0
      ? Future.value(false)
      : size.then((entries) => entries > maxEntries);

  /// Puts a cache entry identified by [key] on the configured [CacheStore]
  ///
  /// * [key]: The cache key
  /// * [entry]: The cache entry
  Future<void> _putStorageEntry(String key, CacheEntry entry) {
    if (entry.valueChanged) {
      return storage
          .putEntry(name, key, entry)
          .then((a) => _capacityExceeded(entry))
          .then((exceeded) {
        if (exceeded) {
          return storage.keys(name).then(
              (ks) => storage.getStats(name, sampler.sample(ks)).then((stats) {
                    final stat = evictionPolicy.select(stats, entry);
                    if (stat != null) {
                      return remove(stat.key);
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
  Future<void> _removeStorageEntry(String key) {
    return storage.remove(name, key);
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
      String key, dynamic value, DateTime now, Duration expiryDuration) {
    // How much time till the expiration of this cache entry
    final duration = expiryDuration ?? expiryPolicy.getExpiryForCreation();
    // We want to create a new entry, let's update it according with the semantics
    // of the configured expiry policy and store it
    final expiryTime = now.add(duration);
    final entry = CacheEntry(key, value, expiryTime, DateTime.now());

    // Check if the entry is expired before adding it to the cache
    if (!entry.isExpired(now)) {
      // Nope, it's not expired let's store it then and return
      return _putStorageEntry(key, entry).then((v) => true);
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
      CacheEntry entry, DateTime now, Duration expiryDuration) {
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
      CacheEntry entry, dynamic value, DateTime now, Duration expiryDuration) {
    final oldValue = entry.value;
    final duration = expiryPolicy.getExpiryForUpdate();
    if (duration != null) {
      // We just need to update the expiry time on the entry
      // according with the expiry policy in place or if provided the expiry duration
      entry.expiryTime = now.add(expiryDuration ?? duration);
    }
    entry.value = value;
    entry.updateTime = now;
    entry.hitCount++;

    // Finally store the entry in the underlining storage
    return _putStorageEntry(entry.key, entry).then((v) => oldValue);
  }

  @override
  Future<dynamic> get(String key, {Duration expiryDuration}) {
    // Gets the entry from the storage
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      final expired = entry != null && entry.isExpired(now);
      // Does this entry exists or is expired ?
      if (entry == null || expired) {
        // If expired we need to remove the value from the storage
        if (expired) {
          _removeStorageEntry(key);
        }

        // Invoke the cache loader
        return cacheLoader(key).then((value) {
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
  Future<void> put(String key, dynamic value, {Duration expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry does not exist or is expired
      if (entry == null || expired) {
        // If expired we remove it first
        if (expired) {
          _removeStorageEntry(key);
        }

        // And finally we add it to the cache
        return _putEntry(key, value, now, expiryDuration);
      } else {
        // Already present let's update the cache instead
        return _updateEntry(entry, value, now, expiryDuration);
      }
    });
  }

  @override
  Future<dynamic /*?*/ > operator [](String key) {
    return get(key);
  }

  @override
  Future<bool> putIfAbsent(String key, dynamic value,
      {Duration expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      if (expired) {
        _removeStorageEntry(key);
      }

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return _putEntry(key, value, now, expiryDuration);
      }

      return Future.value(false);
    });
  }

  @override
  Future<void> clear() {
    return _clearStorage();
  }

  @override
  Future<void> remove(String key) {
    return _removeStorageEntry(key);
  }

  @override
  Future<dynamic> getAndPut(String key, dynamic value,
      {Duration expiryDuration}) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      final now = clock.now();
      var expired = entry != null && entry.isExpired(now);

      // If the entry exists on cache but is already expired we remove it first
      if (expired) {
        _removeStorageEntry(key);
      }

      // If the entry is expired or non existent
      if (entry == null || expired) {
        return _putEntry(key, value, now, expiryDuration).then((v) => null);
      } else {
        return _updateEntry(entry, value, now, expiryDuration);
      }
    });
  }

  @override
  Future<dynamic /*?*/ > getAndRemove(String key) {
    // Try to get the entry from the cache
    return _getStorageEntry(key).then((entry) {
      if (entry != null) {
        return _removeStorageEntry(key)
            .then((any) => entry.isExpired() ? null : entry.value);
      }

      return null;
    });
  }
}
