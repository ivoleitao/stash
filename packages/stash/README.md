# stash

[![Build Status](https://github.com/ivoleitao/stash/actions/workflows/build.yml/badge.svg)](https://github.com/ivoleitao/stash/actions/workflows/build.yml)
[![Pub Package](https://img.shields.io/pub/v/stash.svg?style=flat-square)](https://pub.dartlang.org/packages/stash)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash-blue.svg)](https://www.dartdocs.org/documentation/stash/latest)
[![Github Stars](https://img.shields.io/github/stars/ivoleitao/stash.svg)](https://github.com/ivoleitao/stash)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Overview

The `stash` caching library was designed from ground up with extensibility in mind. It's based on a small core that relies on several extension points and from a feature perspective it supports the most traditional capabilities found on well know caching libraries like expiration or eviction. The API itself was heavily influenced by the JCache spec from the Java world, but draws inspiration from other libraries as well.

3rd party library support was a major concern since it's inception, as such, a library `stash_test` is provided with a complete set of tests that allow the implementers of novel storage and cache frontends to test their implementations against the same baseline tests that were used by the main library.

## Features

* :alarm_clock: **Expiry policies** - out-of-box support for [`Eternal`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/eternal_policy.dart) (default), [`Created`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/created_policy.dart), [`Accessed`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/accessed_policy.dart), [`Modified`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/modified_policy.dart) and [`Touched`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/touched_policy.dart) policies.
* :outbox_tray: **Eviction policies** - out-of-box support for [`FIFO`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/fifo_policy.dart) (first-in, first-out), [`FILO`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/filo_policy.dart) (first-in, last-out), [`LRU`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/lru_policy.dart) (least-recently used), [`MRU`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/mru_policy.dart) (most-recently used), [`LFU`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/lfu_policy.dart) (least-frequently used, the default) and [`MFU`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/mfu_policy.dart) (most frequently used).
* :game_die: **Cache entry sampling** - Sampling of eviction candidates either by sampling the whole set (the default) using the [`Full`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/full_sampler.dart) sampler or in alternative through a [`Random`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/random_sampler.dart) sampling strategy.
* :rocket: **Built in binary serialization** - Provides a out-of-box highly performant binary serialization using [msgpack](https://msgpack.org) with an implementation inspired on the [msgpack_dart](https://pub.dev/packages/msgpack_dart) package and adapted to the specific needs of this library .
* :loop: **Extensible** - Pluggable implementation of custom encoding/decoding, storage, expiry, eviction and sampling strategies.
* :wrench: **Testable** - Storage and cache harness for 3d party support of novel storage and cache frontend strategies
* :hamburger: **Tiered cache** - Allows the configuration of a primary highly performing cache (in-memory for example) and a secondary second-level cache
* :sparkles: **Events** - Provides a set of subscribable cache events, [`CreatedEntryEvent`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/created_entry_event.dart), [`UpdatedEntryEvent`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/updated_entry_event.dart), [`RemovedEntryEvent`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/removed_entry_event.dart), [`ExpiredEntryEvent`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/expired_entry_event.dart) and [`EvictedEntryEvent`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/evicted_entry_event.dart).

## Storage Implementations

There's a vast array of storage implementations available which you can use. 

|Package|Pub|Description|
|-------|---|-----------|
|[stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory)|[![Pub](https://img.shields.io/pub/v/stash_memory.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_memory)|A memory storage implementation|
|[stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file)|[![Pub](https://img.shields.io/pub/v/stash_file.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_file)|A file storage implementation using the [file](https://pub.dev/packages/file) package|
|[stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite)|[![Pub](https://img.shields.io/pub/v/stash_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sqlite)|A sqlite storage implementation using the [moor](https://pub.dev/packages/moor) package|
|[stash_hive](https://github.com/ivoleitao/stash/tree/develop/packages/stash_hive)|[![Pub](https://img.shields.io/pub/v/stash_hive.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_hive)|A hive storage implementation using the [hive](https://pub.dev/packages/hive) package|
|[stash_sembast](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sembast)|[![Pub](https://img.shields.io/pub/v/stash_sembast.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sembast) | A sembast storage implementation using the [sembast](https://pub.dev/packages/sembast) package|
|[stash_objectbox](https://github.com/ivoleitao/stash/tree/develop/packages/stash_objectbox)|[![Pub](https://img.shields.io/pub/v/stash_objectbox.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_objectbox) | A objectbox storage implementation using the [objectbox](https://pub.dev/packages/objectbox) package|

## Library Integrations

There's also some integrations with well know dart libraries

|Package|Pub|Description|
|-------|---|-----------|
|[stash_dio](https://github.com/ivoleitao/stash/tree/develop/packages/stash_dio)|[![Pub](https://img.shields.io/pub/v/stash_dio.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_dio)|Integrates with the Dio HTTP client|

## Test Support

Finally a testing library is provided to aid in the development of third party extensions

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

Finally, to start developing import the corresponding implementation. In the example bellow the in-memory storage provider which you can start using if you import the `stash_memory` library:

```dart
import 'package:stash/stash_memory.dart';
// In a more general sense 'package:stash/stash_xxx.dart' where xxx is the name of the
// storage provider, memory, hive and so on
```

## Usage

### Simple usage

Create a `Cache` using the appropriate storage mechanism. For example on the in-memory implementation you will be using the `newMemoryCache` function exported by the [stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory) package. Note that if the name of the cache is not provided (as in the example bellow) a uuid is automatically assigned as the name:

```dart
  // Creates a memory cache with unlimited capacity
  final cache = newMemoryCache();
  // In a more general sense 'newXXXCache' where xxx is the name of the storage provider, 
  // memory, file, sqlite, hive and so on
```

or alternatively specify a max capacity, 10 for example. Note that the eviction policy is only applied if `maxEntries` is specified

```dart
  // Creates a memory cache with a max capacity of 10
  final cache = newMemoryCache(maxEntries: 10);
  // In a more general sense 'newXXXCache' where xxx is the name of the storage provider, 
  // memory, file, sqlite, hive and so on
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

The in-memory example is the simplest one. Note that on that case there is no persistence so encoding/decoding of elements is not needed. Conversely when the storage mechanism uses persistence and we need to add custom objects they need to be json serializable and the appropriate configuration provided to allow the serialization/deserialization of those objects. This means that on those cases additional configuration is needed to allow the serilization/deserialization to happen.

Find bellow and example that uses [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) as the storage implementation of the cache. In this case an object is stored, so in order to deserialize it the user needs to provide a way to decode it, like so: `fromEncodable: (json) => Task.fromJson(json)`. The lambda should make a call to a user provided function that deserializes the object. Conversly, the serialization happens by convention i.e. by calling the `toJson` method on the object. Note that this example is sufficiently simple to warrant the usage of manual coded functions to serialize/deserialize the objects but could be paired with the [json_serializable](https://pub.dev/packages/json_serializable) package or similar for the automatic generation of the Json serialization / deserialization code.  

```dart
import 'dart:io';

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
    return 'Task $id: "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary path
  final path = Directory.systemTemp.path;

  // Creates a cache on the local storage with the capacity of 10 entries
  final cache = newLocalFileCache(path,
      maxEntries: 10, fromEncodable: (json) => Task.fromJson(json));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(id: 1, title: 'Run stash_file example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
```

You may want to reuse the same store for multiple caches. In order to make use of that feature you will need to create the store first:

```dart
  // Creates a store
  final store = newMemoryStore();
  // In a more general sense 'newXXXStore' where xxx is the name of the storage provider, 
  // memory, file, sqlite, hive and so on
```

Then it's just a matter of instanciating caches from the store as presented bellow where the same memory store is used to create two different caches. This is particulary relevant when using stores like sqlite, hive, file and similar where it's to normal to rely in a unique store.

```dart
  // Creates a cache from the previously created store with a capacity of 10 and name 'cache1'
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10);

  // Creates a second cache from the previously created store with a capacity of 10 and name 'cache2'
  final cache1 = store.cache(
      cacheName: 'cache2',
      maxEntries: 10);
```


### Cache Types

To create a [Cache](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache.dart) we can use the function exported by a specific storage library, `newMemoryCache` in case of the [stash_memory](https://github.com/ivoleitao/stash/tree/develop/packages/stash_memory) library (generically `newXXXCache` where `xxx` is the name of the storage provider).

Note that this is not the only type of cache provided, `stash` also provies a tiered cache which can be created with a call to `newTieredCache` function which is exported by the base `stash` library. It allows the creation of cache that uses primary and secondary cache surrogates an the idea is to have a fast in-memory cache as the primary and a persistent cache as the secondary altough other combinations definitely supported. In this cases it's normal to have a bigger capacity for the secondary and a lower capacity for the primary cache. In the example bellow a new tiered cache is created using two in-memory caches the first with a maximum capacity of 10 and the second with unlimited capacity. 

```dart
  /// Creates a tiered cache with both the primary and the secondary caches using 
  /// a memory based storage. The first cache with a maximum capacity of 10 and 
  /// the second with unlimited capacity
  final cache = newTieredCache(
      newMemoryCache(maxEntries: 10),
      newMemoryCache());
```

A more common use case is to have the primary cache using a memory storage and the secondary a cache backed by a persistent storage like the one provided by [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) or [stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite) packages. The example bellow illustrates one of those use cases with the `stash_file` package as the provider of the storage backend of the secondary cache.

```dart
  final cache = newTieredCache(
      newMemoryCache(maxEntries: 10),
      newFileCache(cacheName: 'diskCache', maxEntries: 1000));
```

## Cache Operations

The [Cache](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache.dart) frontend provides a number of operations which are presented in the table bellow.

| Operation | Description |
| --------- | ----------- |
| `size` | Returns the number of entries on the cache |
| `keys` | Returns all the cache keys |
| `containsKey` | Checks if the cache contains an entry for the specified `key` |
| `get` | Gets the cache value for the specified `key` |
| `put` | Adds / Replace the cache value of the specified `key` |
| `putIfAbsent` | Replaces the specified `key` with the provided `value` if not already set |
| `clear` | Clears the contents of the cache |
| `remove` | Removes the specified `key` value |
| `getAndPut` | Returns the specified `key` cache value and replaces it with `value` |
| `getAndRemove` | Gets the specified `key` cache value and removes it |

### Expiry policies

It's possible to define how the expiration of cache entries works based on creation, access and modification operations. A number of pre-defined expiry polices are provided out-of-box that define multiple combinations of those interactions. Note that, most of the expiry policies can be configured with a specific duration which is used to increase the expiry time when some type of operation is executed on the cache. This mechanism was heavily inspired on the JCache expiry semantics. By default the configuration does not enforce any kind of expiration, thus it uses the[`Eternal`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/eternal_policy.dart) expiry policy. It is of course possible to configure an alternative expiry policy setting the `expiryPolicy` parameter e.g. `newMemoryCache(expiryPolicy: const AccessedExpiryPolicy(Duration(days: 1)))`. Another alternative is to configure a custom expiry policy through the implementation of [ExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/expiry_policy.dart) interface.


| Policy                                                    | Description                                                  |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| [EternalExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/eternal_policy.dart) |  The cache does not expire regardless of the operations executed by the user |
| [CreatedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/created_policy.dart) | Whenever the cache is created the configured duration is appended to the current time. No other operations reset the expiry time |
| [AccessedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/accessed_policy.dart) | Whenever the cache is created or accessed the configured duration is appended to the current time. |
| [ModifiedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/modified_policy.dart) | Whenever the cache is created or updated the configured duration is appended to the current time. |
| [TouchedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/expiry/touched_policy.dart) | Whenever the cache is created, accessed or updated the configured duration is appended to the current time |

When the cache expires it's possible to automate the fetching of a new value from the system of records, through the `cacheLoader` mechanism. The user can provide a [CacheLoader](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache.dart) function that should retrieve a new value for the specified key e.g. `newMemoryCache(cacheLoader: (key) => ...)`. Note that this function must return a `Future`.

### Eviction policies

As discussed `stash` supports eviction as well and provides a number of pre-defined eviction policies that are described in the table bellow. Note that it's mandatory to configure the cache with a number for `maxEntries` e.g. `newMemoryCache(maxEntries: 10)`. Without this configuration the eviction algorithm is not triggered since there is no limit defined for the number of items on the cache. The default algorithm is [`LRU`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/lru_policy.dart) (least-recently used) but other algorithms can be configured through the use of the `evictionPolicy` parameter e.g. `newMemoryCache(evictionPolicy: const LruEvictionPolicy())`. Another alternative is to configure a custom eviction policy through the implementation of [EvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/eviction_policy.dart) interface.

| Policy                                                    | Description                                                  |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| [FifoEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/fifo_policy.dart) | FIFO (first-in, first-out) policy behaves in the same way as a FIFO queue, i.e. it evicts the entries in the order they were added, without any regard to how often or how many times they were accessed before.  |
| [FiloEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/filo_policy.dart) |  FILO (first-in, last-out) policy behaves in the same way as a stack and is the exact opposite of the FIFO queue. The cache evicts the entries added most recently first without any regard to how often or how many times it was accessed before. |
| [LruEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/lru_policy.dart) | LRU (least-recently used) policy discards the least recently used entries first.  |
| [MruEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/mru_policy.dart) | MRU (most-recently used) policy discards, in contrast to LRU, the most recently used entries first. |
| [LfuEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/lfu_policy.dart) | LFU (least-frequently used) policy counts how often an entry is used. Those that are least often used are discarded first. In that sense it works very similarly to LRU except that instead of storing the value of how recently a block was accessed, it stores the value of how many times it was accessed. |
| [MfuEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/eviction/mfu_policy.dart) | MFU (most-frequently used) policy is the exact opposite of LFU. It counts how often a entry is used but it discards those that are most used first. |


When the maximum capacity of a cache is exceeded eviction of one or more entries is inevitable. At that point the eviction algorithm works with a set of entries that are defined by the sampling strategy used. In the default configuration the whole set of entries is used which means that the cache statistics will be retrieved from each and every one of the entries. This works fine for modest sized caches but can became a performance burden for bigger caches. On that cases a more efficient sampling strategy should be selected to avoid sampling the whole set of entities from storage. On those cases it's possible to configure the sampling strategy with the `sampler` parameter e.g. `newMemoryCache(sampler: RandomSampler(0.5))` uses a [`Random`](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/random_sampler.dart) sampler to select only half of the entries as candidates for eviction. The configuration of a custom sampler is also possible through the implementation of the [Sampler](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/sampler.dart) interface.


| Sampler | Description |
| ------- | ----------- |
| [FullSampler](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/full_sampler.dart) | Returns the whole set, no sampling is performed |
| [RandomSampler](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/sampler/random_sampler.dart) | Allows the sampling of a random set of entries selected from the whole set through the definition of a sampling factor |

### Events

The user of a `Cache` can subscribe to cache enty events if they are enabled through configuration as, by default, no events are propagated. The three possible configurations are setted via the `eventListenerMode` parameter. When creating a `Cache` the default value is `Disabled` as in, no events are published, but can be configured with `Sync` providing synchronous events or with `Async` in which case it provides assynchronous events. A user can subscribe all events or only to a specific set of events at the moment of the subscription. On the example bellow a memory cache is created with a maximum of 10 entries subscribing all the events synchronously.

```dart
  // Creates a memory cache with a max capacity of 10 and subscribes to all the 
  // cache events
  final cache = newMemoryCache(maxEntries: 10, eventListenerMode: EventListenerMode.synchronous)
    ..on().listen((event) => print(event));
```


| Event | Description |
| ----- | ----------- |
| [CreatedEntryEvent](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/created_entry_event.dart) | Triggered when a cache entry is created. |
| [UpdatedEntryEvent](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/updated_entry_event.dart) | Triggered when a cache entry is updated. |
| [RemovedEntryEvent](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/removed_entry_event.dart) | Triggered when a cache entry is removed. |
| [ExpiredEntryEvent](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/expired_entry_event.dart) | Triggered when a cache entry expires. | 
| [EvictedEntryEvent](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/event/evicted_entry_event.dart) | Triggered when a cache entry is evicted. |


```dart
  // Creates a memory cache with a max capacity of 10 which subscribes to the Created and 
  // the Updated cache events
  final cache = newMemoryCache(maxEntries: 10, eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen((event) => print(event.type))
    ..on<UpdatedEntryEvent>().listen((event) => print(event.type));
```

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