# stash

[![Build Status](https://github.com/ivoleitao/stash/actions/workflows/dart-ci.yml/badge.svg)](https://github.com/ivoleitao/stash/actions/workflows/dart-ci.yml)
[![Pub Package](https://img.shields.io/pub/v/stash.svg?style=flat-square)](https://pub.dartlang.org/packages/stash)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash-blue.svg)](https://www.dartdocs.org/documentation/stash/latest)
[![Github Stars](https://img.shields.io/github/stars/ivoleitao/stash.svg)](https://github.com/ivoleitao/stash)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Overview

The `stash` library is a key-value store abstraction with a pluggable backend architecture that provides support for vault and cache objects.The vault is a simple key value storage for primitives and objects. The cache goes one step further and adds caching semantics. The design of the cache was heavily influenced by the JCache [spec](https://github.com/jsr107/jsr107spec) from the Java world, albeit it draws inspiration from other libraries as well. It supports the most traditional capabilities found on well know caching libraries like expiration or eviction and all it's core concepts were designed from ground up with extensibility in mind.

3rd party library support was a major concern since the inception, as such, a library `stash_test` is provided with a complete set of tests that allow the developers of novel storage backends to test their implementations against the same baseline tests that were used by the main library.

## History

The `stash` library started it's life as a pure cache library,  however with the multiple versions, it become clear that the pluggable storage backend architecture could be reused to provide a key value abstraction that can be leveraged in other scenarios like the storage of preferences or assets or as a general purpose key value database. With version 4.0.0, comes the first major revision and most of the breaking changes since it's inception. 

## Features

* :rocket: **Binary serialization** - Provides out-of-box highly performant binary serialization using and implementation of [msgpack](https://msgpack.org) inspired on the [msgpack_dart](https://pub.dev/packages/msgpack_dart) package and adapted to the specific needs of this library .
* :sparkles: **Events** - Subscribable events for vault and cache instances, providing notifications on creation, update or removal of an entry and also expiry and eviction notifications for caches.
* :bar_chart: **Statistics** - Supports the capture of vault and cache statistics
* :alarm_clock: **Cache Expiry policies** - out-of-box support for `Eternal`,`Created`, `Accessed`, `Modified` and `Touched` policies.
* :outbox_tray: **Cache Eviction policies** - out-of-box support for `FIFO`(first-in, first-out), `FILO` (first-in, last-out), `LRU` (least-recently used), `MRU` (most-recently used), `LFU` (least-frequently used, the default),  `MFU` (most frequently used) and `Hyperbolic`
* :game_die: **Cache entry sampling** - Sampling of eviction candidates randomly or via reservoir sampling
* :hamburger: **Tiered cache** - Allows the configuration of a primary highly performing cache (in-memory for example) and a secondary second-level cache
* :loop: **Extensible** - Pluggable implementations of custom encoding/decoding, storage, stats, expiry, eviction and sampling strategies.
* :wrench: **Testable** - Storage, vault and cache harness for 3d party support of novel storage backend strategies

## Storage Implementations

There's a vast array of storage implementations available which you can use. 

|Package|Pub|Description|
|-------|---|-----------|
|[stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory)|[![Pub](https://img.shields.io/pub/v/stash_memory.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_memory)|A memory storage implementation|
|[stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file)|[![Pub](https://img.shields.io/pub/v/stash_file.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_file)|A file storage implementation using the [file](https://pub.dev/packages/file) package|
|[stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite)|[![Pub](https://img.shields.io/pub/v/stash_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sqlite)|A sqlite storage implementation using the [drift](https://pub.dev/packages/drift) package|
|[stash_hive](https://github.com/ivoleitao/stash/tree/develop/packages/stash_hive)|[![Pub](https://img.shields.io/pub/v/stash_hive.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_hive)|A hive storage implementation using the [hive](https://pub.dev/packages/hive) package|
|[stash_sembast](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sembast)|[![Pub](https://img.shields.io/pub/v/stash_sembast.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sembast) | A sembast storage implementation using the [sembast](https://pub.dev/packages/sembast) package|
|[stash_sembast_web](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sembast_web)|[![Pub](https://img.shields.io/pub/v/stash_sembast_web.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sembast_web) | A sembast web storage implementation using the [sembast_web](https://pub.dev/packages/sembast_web) package|
|[stash_objectbox](https://github.com/ivoleitao/stash/tree/develop/packages/stash_objectbox)|[![Pub](https://img.shields.io/pub/v/stash_objectbox.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_objectbox) | A objectbox storage implementation using the [objectbox](https://pub.dev/packages/objectbox) package|
|[stash_cbl](https://github.com/ivoleitao/stash/tree/develop/packages/stash_cbl)|[![Pub](https://img.shields.io/pub/v/stash_cbl.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_cbl) | A Couchbase Lite storage implementation using the [cbl](https://pub.dev/packages/cbl) package|

## Library Integrations

There's also some integrations with well know dart libraries

|Package|Pub|Description|
|-------|---|-----------|
|[stash_dio](https://github.com/ivoleitao/stash/tree/develop/packages/stash_dio)|[![Pub](https://img.shields.io/pub/v/stash_dio.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_dio)|Integrates with the Dio HTTP client|

## Test Support

Finally a testing library is provided to aid in the development of third party storage backend extensions

|Package|Pub|Description|
|-------|---|-----------|
|[stash_test](https://github.com/ivoleitao/stash/tree/develop/packages/stash_test)|[![Pub](https://img.shields.io/pub/v/stash_test.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_test)|Testing support for `stash` extensions|

## Getting Started

Select one of the storage implementation libraries and add the package to your `pubspec.yaml` replacing x.x.x with the latest version of the storage implementation. The example below uses the `stash_memory` package which provides an in-memory implementation:

```dart
dependencies:
    stash_memory: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the corresponding implementation. In the example bellow it's the in-memory storage provider which you can start using if you import the `stash_api`and the `stash_memory` libraries:

```dart
import 'package:stash/stash_api.dart';
import 'package:stash/stash_memory.dart';
// In a more general sense 'package:stash/stash_xxx.dart' where xxx is the name of the
// storage provider, memory, hive and so on
```

## Usage

Start by creating an instance of the storage backend. For example, on the in-memory implementation for vaults you will be using the `newMemoryVaultStore` function exported by the [stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory) package. This function allows the user to bootstrap a in-memory store for vaults. Note that there is a similar one for caches dubbed `newMemoryCacheStore`

```dart
  // Create a in-memory store
  final store = await newMemoryVaultStore();
  // In a more general sense 'newXXXVaultStore' or 'newXXXCacheStore' where xxx is the name of the storage provider,
  // memory, file, sqlite, hive and so on
```

Then you can create as many vault's as you wish from this store. Let's create one to store string's and add an element to it

```dart
  // Creates a vault from the previously created store
  final stringVault = await store.vault<String>();

  // Adds a new value to the vault
  await stringVault.put('key1', 'value1');
```

Let's create a untyped vault and add two values to it

```dart
  // Creates a second vault from the previously created store
  final anyVault = await store.vault();

    // Adds a string value to the vault
  await anyVault.put('key1', 'value1');

    // Adds an int value to the vault
  await anyVault.put('key1', 1);
```

On both cases if the name of the vault is not provided a uuid is automatically assigned as the name. By using different names you can reuse the same storage and partition your data accordingly

Now let's create a cache. In this case a new type of store is needed as the cache needs additional fields to support expiry and eviction. In the example bellow a store is created followed by a cache with a max capacity of 10. *Note:* that the eviction policy is only applied if `maxEntries` is specified

```dart
  // Creates a in-memory store
  final store = await newMemoryCacheStore();

  // Creates a cache with a max capacity of 10 from the previously created store
  final cache = await store.cache<String>(maxEntries: 10);
```

Then add a element to the cache:

```dart
  // Adds a 'value1' under 'key1' to the cache
  await cache.put('key1', 'value1');
```

Finally, retrieve that element:

```dart
  // Retrieves the value from the cache
  final value = await cache.get('key1');
```

The in-memory example is the simplest one, on that case there is no persistence so encoding/decoding of elements is not needed. Conversely when the storage mechanism uses persistence and we need to add custom objects they need to be json serializable and the appropriate configuration provided to allow the serialization/deserialization of those objects. This means that on those cases additional configuration is needed to allow the serilization/deserialization to happen.

Find bellow and example that uses [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) as the storage implementation. In this case an object is stored, so in order to deserialize it the user needs to provide a way to decode it, like so: `fromEncodable: (json) => Task.fromJson(json)`. The lambda should make a call to a user provided function that deserializes the object. Conversly, the serialization happens by convention i.e. by calling the `toJson` method on the object. Note that this example is sufficiently simple to warrant the usage of manual coded functions to serialize/deserialize the objects but it could be paired with the [json_serializable](https://pub.dev/packages/json_serializable) package or similar for the automatic generation of the Json serialization / deserialization code.  

```dart
import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_file/stash_file.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  /// Creates a [Task] from json map
  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool);

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'completed': completed};

  @override
  String toString() {
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary directory
  final path = Directory.systemTemp.path;

  // Creates a store
  final store = await newFileLocalCacheStore(
      path: path, fromEncodable: (json) => Task.fromJson(json));

  // Creates a cache with a capacity of 10 from the previously created store
  final cache = await store.cache<Task>(
      name: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CacheEntryCreatedEvent<Task>>().listen(
        (event) => print('Key "${event.entry.key}" added to the cache'));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(id: 1, title: 'Run cache store example', completed: true));
  // Retrieves the value from the cache
  print(await cache.get('task1'));
}
```

## Vault

### Operations

The `Vault` frontend provides a number of operations which are presented in the table bellow.

| Operation | Description |
| --------- | ----------- |
| `name` | Returns the name of the vault |
| `size` | Returns the number of entries on the vault |
| `keys` | Returns all the vault keys |
| `containsKey` | Checks if the vault contains an entry for the specified `key` |
| `get` | Gets the vault value for the specified `key` |
| `getAll` | Gets the vault values of the specified set of `keys` |
| `put` | Adds / Replace the vault value of the specified `key` |
| `putAll` | Adds / Replaces the vault values with the specified map of key / values  | 
| `putIfAbsent` | Replaces the specified `key` with the provided `value` if not already set |
| `clear` | Clears the contents of the vault |
| `remove` | Removes the specified `key` value |
| `removeAll`| Removes the specified `keys` values |
| `getAndPut` | Returns the specified `key` vault value and replaces it with `value` |
| `getAndRemove` | Gets the specified `key` vault value and removes it |
| `manager` | Returns the vault manager |
| `statsEnabled`| If the stats are enabled |
| `stats` | Returns the vault stats |
| `on` | Allows the subscription of vault events |

### Events

The user of a `Vault` can subscribe to entry events if they are enabled as, by default, no events are propagated. The three possible configurations are setted via the `eventListenerMode` parameter. When creating a `Vault` the default value is `Disabled` as in, no events are published, but can be configured with `Sync` providing synchronous events or with `Async` in which case it provides assynchronous events. A user can subscribe all events or only to a specific set of events. On the example bellow a memory vault is created subscribing all the events synchronously.

```dart
  // Creates a vault from a previously created store subscribing to the created, updated, removed events
  final vault = await store.vault<String>(
      eventListenerMode: EventListenerMode.synchronous)
    ..on<VaultEntryCreatedEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" added'))
    ..on<VaultEntryUpdatedEvent<String>>().listen(
        (event) => print('Key "${event.newEntry.key}" updated'))
    ..on<VaultEntryRemovedEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" removed'));
```


| Event | Description |
| ----- | ----------- |
| `VaultEntryCreatedEvent` | Triggered when a vault entry is created. |
| `VaultEntryUpdatedEvent` | Triggered when a vault entry is updated. |
| `VaultEntryRemovedEvent` | Triggered when a Vault entry is removed. |


### Statistics

The user of a `Vault` can collect a number of statistics about it's usage by enabling stats through the `statsEnabled`. He can also provide a custom implementation of the `VaultStats` interface allowing custom statistics backends. The `VaultStats` interface defines a number of statistics that the user can collect through the following operations:

| Operation | Description |
| --------- | ----------- |
| `gets` | Returns the number of get requests satisfied by the vault |
| `puts` | Returns the number of puts satisfied by the vault |
| `removals` | Returns the number of removals satisfied by the vault |
| `averageGetTime` | Returns the mean time to execute gets in milliseconds |
| `averagePutTime` | Returns the mean time to execute puts in milliseconds |
| `averageRemoveTime` | Returns the mean time to execute a remove in milliseconds |
| `clear` | Clears the statistics counters to 0 for the associated vault. |

## Cache

### Operations

The `Cache` frontend provides a number of operations which are presented in the table bellow.

| Operation | Description |
| --------- | ----------- |
| `size` | Returns the number of entries on the cache |
| `keys` | Returns all the cache keys |
| `containsKey` | Checks if the cache contains an entry for the specified `key` |
| `get` | Gets the cache value for the specified `key` |
| `getAll` | Gets the cache values of the specified set of `keys` |
| `put` | Adds / Replace the cache value of the specified `key` |
| `putAll` | Adds / Replaces the cache values with the specified map of key / values  | 
| `putIfAbsent` | Replaces the specified `key` with the provided `value` if not already set |
| `clear` | Clears the contents of the cache |
| `remove` | Removes the specified `key` value |
| `removeAll`| Removes the specified `keys` values |
| `getAndPut` | Returns the specified `key` cache value and replaces it with `value` |
| `getAndRemove` | Gets the specified `key` cache value and removes it |
| `manager` | Returns the cache manager |
| `statsEnabled`| If the stats are enabled |
| `stats` | Returns the cache stats |
| `on` | Allows the subscription of cache events |

### Types

To create a `Cache` we can use the function exported by a specific storage library, `newMemoryCacheStore` in case of the [stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory) library (generically `newXXXCacheStore` where `xxx` is the name of the storage provider).

Note that this is not the only type of cache provided, `stash` also provies a tiered cache which can be created with a call to `newTieredCache` function which is exported by the base `stash` library. It allows the creation of a cache that uses primary and secondary cache surrogates. The idea is to have a fast in-memory cache as the primary and a persistent cache as the secondary altough other combinations are definitely supported. In this cases it's normal to have a bigger capacity for the secondary and a lower capacity for the primary cache. In the example bellow a new tiered cache is created using two in-memory caches the first with a maximum capacity of 10 and the second with unlimited capacity. 

```dart
  // Creates a in-memory store
  final store = await newMemoryCacheStore();

  /// Creates a tiered cache with both the primary and the secondary caches using 
  /// a memory based storage. The first cache with a maximum capacity of 10 and 
  /// the second with unlimited capacity
  final cache = newTieredCache(
      await store.cache<String>(maxEntries: 10),
      await store.cache<String>());
```

A more common use case is to have the primary cache using a memory storage and the secondary a cache backed by a persistent storage like the one provided by [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) or [stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite) packages. The example bellow illustrates one of those use cases with the `stash_file` package as the provider of the storage backend of the secondary cache.

```dart
  // Creates a in-memory store
  final memoryStore = await newMemoryCacheStore();

  // Creates a file store
  final fileStore = await newFileLocalCacheStore(path: Directory.systemTemp.path);  

  final cache = newTieredCache(
      await memoryStore.cache<String>(name: 'memoryCache', maxEntries: 10),
      await fileStore.cache(name: 'diskCache', maxEntries: 1000));
```

### Expiry Policies

It's possible to define how the expiration of cache entries works based on creation, access and modification operations. A number of pre-defined expiry polices are provided out-of-box that define multiple combinations of those interactions. Note that, most of the expiry policies can be configured with a specific duration which is used to increase the expiry time when some type of operation is executed on the cache. This mechanism was heavily inspired on the JCache expiry semantics. By default the configuration does not enforce any kind of expiration, thus it uses the `Eternal` expiry policy. It is of course possible to configure an alternative expiry policy setting the `expiryPolicy` parameter e.g. `store.cache(expiryPolicy: const AccessedExpiryPolicy(Duration(days: 1)))`. Another alternative is to configure a custom expiry policy through the implementation of the `ExpiryPolicy` interface.

| Policy | Description |
| ------ | ----------- |
| `EternalExpiryPolicy` | The cache does not expire regardless of the operations executed by the user |
| `CreatedExpiryPolicy` | Whenever the cache is created the configured duration is appended to the current time. No other operations reset the expiry time |
| `AccessedExpiryPolicy` | Whenever the cache is created or accessed the configured duration is appended to the current time. |
| `ModifiedExpiryPolicy` | Whenever the cache is created or updated the configured duration is appended to the current time. |
| `TouchedExpiryPolicy` | Whenever the cache is created, accessed or updated the configured duration is appended to the current time. |

When the cache expires it's possible to automate the fetching of a new value from the system of records, through the `cacheLoader` mechanism. The user can provide a `CacheLoader` function that should retrieve a new value for the specified key e.g. `store.cache(cacheLoader: (key) => ...)`. Note that this function must return a `Future`.

### Eviction Policies

As discussed `Cache` supports eviction and provides a number of pre-defined eviction policies that are described in the table bellow. Note that it's mandatory to configure the cache with a number for `maxEntries` e.g. `store.cache(maxEntries: 10)`. Without this configuration the eviction algorithm is not triggered since there is no limit defined for the number of items on the cache. The default algorithm is `LRU` (least-recently used) but other algorithms can be configured through the use of the `evictionPolicy` parameter e.g. `store.cache(evictionPolicy: const HyperbolicEvictionPolicy())`. Another alternative is to configure a custom eviction policy through the implementation of the `EvictionPolicy` interface.

| Policy | Description |
| ------ | ----------- |
| `FifoEvictionPolicy` | FIFO (first-in, first-out) policy behaves in the same way as a FIFO queue, i.e. it evicts the entries in the order they were added, without any regard to how often or how many times they were accessed before. |
| `FiloEvictionPolicy` |  FILO (first-in, last-out) policy behaves in the same way as a stack and is the exact opposite of the FIFO queue. The cache evicts the entries added most recently first without any regard to how often or how many times it was accessed before. |
| `LruEvictionPolicy` | LRU (least-recently used) policy discards the least recently used entries first.  |
| `MruEvictionPolicy` | MRU (most-recently used) policy discards, in contrast to LRU, the most recently used entries first. |
| `LfuEvictionPolicy` | LFU (least-frequently used) policy counts how often an entry is used. Those that are least often used are discarded first. In that sense it works very similarly to LRU except that instead of storing the value of how recently a block was accessed, it stores the value of how many times it was accessed. |
| `MfuEvictionPolicy` | MFU (most-frequently used) policy is the exact opposite of LFU. It counts how often a entry is used but it discards those that are most used first. |
| `HyperbolicEvictionPolicy` | Hyperbolic policy, combines the LRU and LFU semantics through the use of a priority function defined as `pr(i) = number of accsses / time since i entered the cache`. With this strategy it's possible to address some of the problems of the LFU policy by measuring relative popularity |

When the maximum capacity of a cache is exceeded eviction of one or more entries is inevitable. At that point the eviction algorithm works with a set of entries that are defined by the sampling strategy used. In the default configuration the whole set of entries is used which means that the cache statistics will be retrieved from each and every one of the entries. This works fine for modest sized caches but can became a performance burden for bigger caches. On that cases a more efficient sampling strategy should be selected to avoid sampling the whole set of entities from storage. On those cases it's possible to configure the sampling strategy with the `sampler` parameter e.g. `newMemoryCache(sampler: ReservoirSampler(0.5))` uses a `ReservoirSampler` sampler to select only half of the entries as candidates for eviction. The configuration of a custom sampler is also possible through the implementation of the KeySampler interface.


| Sampler | Description |
| ------- | ----------- |
| `FullSampler` | Returns the whole set, no sampling is performed |
| `ShuffleSampler` | A sampler that shuffles the elements from a list of keys and takes a sample |
| `ReservoirSampler` | An implementation of the reservoir sampling algorithm |

### Events

The user of a `Cache` can subscribe to entry events if they are enabled as, by default, no events are propagated. The three possible configurations are setted via the `eventListenerMode` parameter. When creating a `Cache` the default value is `Disabled` as in, no events are published, but can be configured with `Sync` providing synchronous events or with `Async` in which case it provides assynchronous events. A user can subscribe all events or only to a specific set of events. On the example bellow a memory cache is created with a maximum of 10 entries subscribing all the events synchronously.

```dart
  // Creates a cache with a capacity of 10 from a previously created store subscribing to the created, updated, removed, expired and evicted events
  final cache = await store.cache<String>(
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CacheEntryCreatedEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" added'))
    ..on<CacheEntryUpdatedEvent<String>>().listen(
        (event) => print('Key "${event.newEntry.key}" updated'))
    ..on<CacheEntryRemovedEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" removed'))
    ..on<CacheEntryExpiredEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" expired'))
    ..on<CacheEntryEvictedEvent<String>>().listen(
        (event) => print('Key "${event.entry.key}" evicted')); 
```


| Event | Description |
| ----- | ----------- |
| `CacheEntryCreatedEvent` | Triggered when a cache entry is created. |
| `CacheEntryUpdatedEvent` | Triggered when a cache entry is updated. |
| `CacheEntryRemovedEvent` | Triggered when a cache entry is removed. |
| `CacheEntryExpiredEvent` | Triggered when a cache entry expires. | 
| `CacheEntryEvictedEvent` | Triggered when a cache entry is evicted. |

### Statistics

The user of a `Cache` can collect a number of statistics about it's usage by enabling stats through the `statsEnabled`. He can also provide a custom implementation of the `CacheStats` interface allowing custom statistics backends. 

The `CacheStats` interface defines a number of statistics that the user can collect through the following operations:

| Operation | Description |
| --------- | ----------- |
| `gets` | Returns the number of get requests satisfied by the cache |
| `getPercentage` | Returns the percentage of successful gets, as a decimal e.g 75 |
| `misses` | Returns the number of cache misses |
| `missPercentage` | Returns the percentage of accesses that failed to find anything|
| `requests` | Returns the number of requests to the cache |
| `puts` | Returns the number of puts satisfied by the cache |
| `removals` | Returns the number of removals satisfied by the cache |
| `averageGetTime` | Returns the mean time to execute gets in milliseconds |
| `averagePutTime` | Returns the mean time to execute puts in milliseconds |
| `averageRemoveTime` | Returns the mean time to execute a remove in milliseconds |
| `expiries` | Returns the number of cache expiries |
| `evictions` | Returns the number of cache evictions |
| `clear` | Clears the statistics counters to 0 for the associated cache. |

## Contributing

Contributions are always welcome!

If you would like to contribute with other parts of the API, feel free to make a Github [pull request](https://github.com/ivoleitao/stash/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

See [CONTRIBUTING.md](https://github.com/ivoleitao/stash/blob/develop/CONTRIBUTING.md) for ways to get started.

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/LICENSE) file for details
