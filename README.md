# stash
A caching library build with extensibility in mind

[![Pub Package](https://img.shields.io/pub/v/stash.svg?style=flat-square)](https://pub.dartlang.org/packages/stash)
[![Build Status](https://github.com/ivoleitao/stash/workflows/build/badge.svg)](https://github.com/ivoleitao/stash/actions)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash-blue.svg)](https://www.dartdocs.org/documentation/stash/latest)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Introduction

`Stash` caching library was designed from ground up with extensibility in mind. On it's core provides a simple in-memory cache but supports a vast array of other storage mechanisms as opt-in libraries. It can be used as an extension to other libraries as well to bring a cache layer where none was supported. From a feature perspective it supports the most traditional capabilities found on caching libraries since it was heavily based on the JCache spec from the Java world, however it draws inspiration from other libraries as well. It supports expiration, eviction and binary serialization via a number of algorithms provided out-of-the box which can be extended with a custom provided implementation through well defined contracts. 

3rd party library developers support is well defined as well. The library provides a harness with a number of tests that allow the implementers of novel storage and cache frontend to test their implementations against the same baseline tests that were used to validate the in-memory reference implementation

## Capabilities

* Expiry policies definition, with out-of-box support for [`Eternal`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/eternal_policy.dart) (default), [`Created`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/created_policy.dart), [`Accessed`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/accessed_policy.dart), [`Modified`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/modified_policy.dart) and [`Touched`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/touched_policy.dart) policies
* Support for different eviction mechanisms, with out-of-box support for [`FIFO`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/fifo_policy.dart) (first-in, first-out), [`FILO`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/filo_policy.dart) (first-in, last-out), [`LRU`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/lru_policy.dart) (least-recently used), [`MRU`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/mru_policy.dart) (most-recently used), [`LFU`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/lfu_policy.dart) (least-frequently used, the default) and [`MFU`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/mfu_policy.dart) (most frequently used)
* The eviction of the cache uses a sampling approach to collect the candidate items. It currently samples the whole set using the [`Full`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/full_sampler.dart) sampler but also supports a [`Random`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/random_sampler.dart) sampling strategy
* Definition of a cache loader to be used upon expiration of the cache
* If permitted by the storage implementation it supports the update of only the cache entry header when recording the statistic fields (hit count, access time, expiry time and so on) without replacing the whole value. 
* Out-of-box highly performing binary serialization using [msgpack](https://msgpack.org) that was inspired on the [msgpack_dart](https://pub.dev/packages/msgpack_dart) package and adapted to the specific needs of this library 
* Pluggable implementation of custom encoding/decoding, storage, expiry, eviction and sampling strategies.
* Storage and cache harness for 3d party support of novel storage and cache frontend strategies
* Tiered cache support allowing the configuration of a primary highly performing cache (in-memory for example) and a secondary second-level cache

## Getting Started

Add this to your `pubspec.yaml` (or create it):

```dart
dependencies:
    stash: ^1.0.0-dev.1
```

Run the following command to install dependencies:

```dart
pub install
```

Optionally use the following command to run the tests:

```dart
pub run test
```

Finally, to start developing import one of the implementations. The standalone `stash` library provides a in-memory storage provider that you can start using if you import `stash_memory` library:

```dart
import 'package:stash/stash_memory.dart';
```

But there is a vast array of storage implementations available which you can use. 

| Plugins                                                    | Status                                                       | Description                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [stash_disk](https://github.com/ivoleitao/stash_disk) | [![Pub](https://img.shields.io/pub/v/stash_disk.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_disk) | A disk storage implementation                                     |
| [stash_moor](https://github.com/ivoleitao/stash_moor) | [![Pub](https://img.shields.io/pub/v/stash_moor.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_moor) | A Moor storage implementation using the [moor](https://pub.dev/packages/moor) package                                     |
| [stash_hive](https://github.com/ivoleitao/stash_hive) | [![Pub](https://img.shields.io/pub/v/stash_hive.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_hive) | A Hive storage implementation using the [hive](https://pub.dev/packages/hive) package                                     |
| [stash_sembast](https://github.com/ivoleitao/stash_sembast) | [![Pub](https://img.shields.io/pub/v/stash_sembast.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sembast) | A Sembast storage implementation using the [sembast](https://pub.dev/packages/sembast) package                                     |

There's also some integrations with well know dart libraries

| Plugins                                                    | Status                                                       | Description                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [stash_dio](https://github.com/ivoleitao/stash_dio) | [![Pub](https://img.shields.io/pub/v/stash_dio.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_dio) | Integrates with the Dio HTTP client                             |

## Usage

### Simple usage

Create a `Cache` using the appropriate storage mechanism. This package provides a out-of-box in-memory storage implementation but as mentioned above there are other types of storage mechanisms available.

Start, importing the appropriate implementation, for example the in-memory one:

```dart
import 'package:stash/stash_memory.dart';
// In a more general sense 'package:stash/stash_xxx.dart' where xxx is the name of the storage provider, 
// memory, disk, moor, hive and so on
```

Then create a new cache with the `newMemoryCache` function specifying the cache name (if not provided a uuid is automatically assigned as the name):

```dart
  // Creates a memory cache with unlimited capacity
  final cache = newMemoryCache();
// In a more general sense 'newXXXCache' where xxx is the name of the storage provider, 
// memory, disk, moor, hive and so on
```

or alternatively specify a max capacity, 10 for example. Note that the eviction policy is only applied if `maxEntries` is specified

```dart
  // Creates a memory cache with a max capacity of 10
  final cache = newMemoryCache(maxEntries: 10);
// In a more general sense 'newXXXCache' where xxx is the name of the storage provider, 
// memory, disk, moor, hive and so on
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

The in-memory example is the simplest one. In this case there is no persistence so encoding/decoding of elements is not needed. Conversely when the storage mechanism uses persistence and we need to add custom objects they need to be json serializable and the appropriate configuration provided to allow the serialization/deserialization of those objects. All the other implementations of storage mechanisms need that additional configuration. The exception in this case is the in-memory storage.

Find bellow and example that uses [stash_disk](https://github.com/ivoleitao/stash_disk) as the storage implementation of the cache. In this case an object is stored and therefore to output the correct object the user needs to provide an additional parameter: `fromEncodable: (json) => User.fromJson(json)`. The lambda should make a call to a user provided function that deserializes the object. The serialization happens by convention calling the `toJson` method on the object. Note that this example is sufficiently simple to warrant the usage of manual coded functions to serialize/deserialize the objects but should be paired with the [json_serializable](https://pub.dev/packages/json_serializable) package or similar for the automatic generation of the classes.  

```dart
  import 'dart:io';
  import 'package:stash_disk/stash_disk.dart';

  class User {
    final int id;
    final String title;
    final bool completed;

    User({this.id, this.title, this.completed = false});

    /// Creates a [User] from json map
    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        title: json['title'] as String,
        completed: json['completed'] as bool);

    /// Creates a json map from a [User]
    Map<String, dynamic> toJson() =>
        <String, dynamic>{'id': id, 'title': title, 'completed': completed};

    @override
    String toString() {
      return 'Task ${id}: "${title}" is ${completed ? "completed" : "not completed"}';
    }
  }

  void main() async {
    // Temporary path
    final path = Directory.systemTemp.path;

    // Creates a disk based cache with a capacity of 10
    final cache = newDiskCache(path,
        maxEntries: 10, fromEncodable: (json) => User.fromJson(json));

    // Adds a user with key 'user1' to the cache
    await cache.put(
        'user1', User(id: 1, title: 'Run stash example', completed: true));
    // Retrieves the user from the cache
    final value = await cache.get('user1');

    print(value);
  }

```

### Cache Types

To create a [Cache](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) we can use the function exported by this library, `newMemoryCache` (`newXXXCache` where `xxx` is the name of the storage provider for the more general case) to create a standard cache. There is another type of cache provided, the so called tiered cache that can be created with a call to `newTieredCache`. It allows the creation of cache that uses primary and secondary cache surrogates. The idea is to have a fast in-memory cache as the primary and a persistent cache as the secondary. In this cases it's normal to have a bigger capacity for the secondary and a lower capacity for the primary. In the example bellow a new tiered cache is created using two in-memory caches the first with a maximum capacity of 10 and the second with unlimited capacity. 

```dart
  /// Creates a tiered cache with both the primary and the secondary caches using a memory based storage
  /// The first cache with a maximum capacity of 10 and the second with unlimited capacity
  final cache = newTieredCache(
      newMemoryCache(maxEntries: 10),
      newMemoryCache());
```

A more common use case is to have the primary cache using a memory storage and the secondary a cache backed by a persistent storage like the one provided by [stash_disk](https://github.com/ivoleitao/stash_disk) or [stash_moor](https://github.com/ivoleitao/stash_moor). The example bellow illustrates one of those use cases using the `stash_disk` package as the provider of the storage backend of the secondary cache.

```dart
  final cache = newTieredCache(
      newMemoryCache(maxEntries: 10),
      newDiskCache(cacheName: 'diskCache', maxEntries: 1000));
```

## Cache Operations

The [Cache](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) frontend provides, as expected, a number of other operations besides the ones mentioned in the previous sections. The table bellow gives a general overview of those operations.

| Operation                                                 | Description                                                          |
| --------------------------------------------------------- | -------------------------------------------------------------------- |
| [size](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Returns the number of entries on the cache |
| [keys](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Returns all the cache keys |
| [containsKey](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Checks if the cache contains an entry for the specified `key` |
| [get](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Gets the cache value for the specified `key` |
| [put](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Adds / Replace the cache value of the specified `key` |
| [putIfAbsent](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Replaces the specified `key` with the provided `value` if not already set |
| [clear](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Clears the contents of the cache |
| [remove](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Removes the specified `key` value |
| [getAndPut](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Returns the specified `key` cache value and replaces it with `value` |
| [getAndRemove](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) | Gets the specified `key` cache value and removes it |

### Expiry policies

It's possible to define how the expiration of cache entries works based on creation, access and modification operations. A number of pre-defined expiry polices are provided out-of-box that define multiple combinations of those interactions ultimately defining which user interactions with the cache affect the expiration of entries. Most of the expiry policies can be configured with a specific duration that is used to increase the expiry time when some type of operation is executed on the cache. This mechanism was heavily inspired on the JCache expiry semantics. By default the configuration does not enforce any kind of expiration through the use of [`Eternal`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/eternal_policy.dart) expiry policy, but it's possible to configure an alternative one through the use of the `expiryPolicy` parameter e.g. `newMemoryCache(expiryPolicy: const AccessedExpiryPolicy(Duration(days: 1)))`. Another alternative is to configure a custom expiry policy through the implementation of [ExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/expiry_policy.dart).


| Policy                                                    | Description                                                  |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| [EternalExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/eternal_policy.dart) |  The cache does not expire regardless of the operations executed by the user |
| [CreatedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/created_policy.dart) | Whenever the cache is created the configured duration is appended to the current time. No other operations reset the expiry time |
| [AccessedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/accessed_policy.dart) | Whenever the cache is created of accessed the configured duration is appended to the current time. |
| [ModifiedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/modified_policy.dart) | Whenever the cache is created or updated the configured duration is appended to the current time. |
| [TouchedExpiryPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/expiry/touched_policy.dart) | Whenever the cache is created, accessed or updated the configured duration is appended to the current time |

When the cache expires it's possible to automate the fetching of a new value from the system of records, through the `cacheLoader` parameter. The user can provide a [CacheLoader](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) function that is able to retrieve a new value for the specified key e.g. `newMemoryCache(cacheLoader: (key) => ...)`. Note that this function must return a `Future`.

### Eviction policies

As already discussed `Stash` supports eviction as well and provides a number of pre-defined eviction policies that are described in the table bellow. Note that it's mandatory to configure the cache with a number for `maxEntries` e.g. `newMemoryCache(maxEntries: 10)`. Without this configuration the eviction algorithm is not triggered since there is no limit defined for the number of items on the cache. The default algorithm is [`LRU`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/lru_policy.dart) (least-recently used) but other algorithms can be configured through the use of the `evictionPolicy` parameter e.g. `newMemoryCache(evictionPolicy: const LruEvictionPolicy())`. Another alternative is to configure a custom eviction policies through the implementation of [EvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/eviction_policy.dart).

| Policy                                                    | Description                                                  |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| [FifoEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/fifo_policy.dart) | FIFO (first-in, first-out) policy behaves in the same way as a FIFO queue, i.e. it evicts the blocks in the order they were added, without any regard to how often or how many times they were accessed before.  |
| [FiloEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/filo_policy.dart) |  FILO (first-in, last-out) policy behaves in the same way as a stack and is the exact opposite of the FIFO queue. The cache evicts the block added most recently first without any regard to how often or how many times it was accessed before. |
| [LruEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/lru_policy.dart) | LRU (least-recently used) policy discards the least recently used items first.  |
| [MruEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/mru_policy.dart) | MRU (most-recently used) policy discards, in contrast to LRU, the most recently used items first. |
| [LfuEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/lfu_policy.dart) | LFU (least-frequently used) policy counts how often an item is needed. Those that are used least often are discarded first. It works very similarly to LRU except that instead of storing the value of how recently a block was accessed, it stores the value of how many times it was accessed. |
| [MfuEvictionPolicy](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/eviction/mfu_policy.dart) | MFU (most-frequently used) policy is the exact opposite of LFU. It counts how often a item is need but it discards those that a most used first. |


When the maximum capacity of a cache is exceeded eviction of one or more entries is inevitable. At that point the eviction algorithm works with a set of entries that are defined by the sampling strategy used. In the default configuration the whole set of entries is used which means that the cache statistic will be retrieved from each and every one of the entries. This works fine for modest sized caches but can became a performance burden for bigger caches. On that cases a more efficient sampling strategy should be selected to avoid sampling the whole set of entities from storage. On those cases it's possible to configure the cache with a sampling strategy through the use of the `sampler` parameter e.g. `newMemoryCache(sampler: RandomSampler(0.5))` uses a [`Random`](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/random_sampler.dart) sampler to select only half of the entries as candidates for eviction. The configuration of a custom sampler is also possible through the implementation of [Sampler](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/sampler.dart).


| Sampler                                                   | Description                                                  |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| [FullSampler](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/full_sampler.dart) |  Returns the whole set, no sampling is performed |
| [RandomSampler](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/sampler/random_sampler.dart) |  Allows the sampling of a random set of entries selected from the whole set through the definition of a factor |


## Contributing

`Stash` is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a [Github pull request](https://github.com/ivoleitao/stash/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

### Using the Storage and Cache Harnesses

The `Stash` library provides a way to easily import the set of standard tests that are used for the reference implementations of [CacheStore](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache_store.dart) and the reference implementation of the [Cache](https://github.com/ivoleitao/stash/blob/develop/lib/src/api/cache.dart) and to run them over custom implementations provided by external parties. It also provides as number of classes that allow the generation of values which can be used in each one of the tests:
* `BoolGenerator`
* `IntGenerator`
* `DoubleGenerator`
* `StringGenerator`
* `IteratorGenerator`
* `MapGenerator`
* `SampleClassGenerator`


Find bellow an example implementation to test a `CustomStore` and/or a `CustomCache`

```dart
// Import the stash harness
import 'package:stash/stash_harness.dart';
// Import your custom extension here
import 'package:stash_disk/stash_custom.dart';
// Import the test package
import 'package:test/test.dart';

void main() async {
  // Optionally provide a implementation of the function that creates a store, 
  // you can use the exported function `newMemoryStore` instead
  Future<CustomStore> newStore(
      {dynamic Function(Map<String, dynamic>) fromEncodable}) {
    ...
  }

  // Optionally provide a implementation of the function that creates a custom cache, 
  // you can use the exported function `newDefaultCache` instead
  CustomCache newCache<T extends CacheStore>(T store,
      {String name,
      ExpiryPolicy expiryPolicy,
      KeySampler sampler,
      EvictionPolicy evictionPolicy,
      int maxEntries,
      CacheLoader cacheLoader,
      Clock clock}) {
    ...
  }

  // Optionally provide a implementation of the function that deletes a store. 
  // If you used the `newMemoryStore` function to create the store
  // you can use the exported function `deleteMemoryStore` instead
  Future<void> deleteStore(CustomStore store) {
    ...
  }

  // Test a custom store and/or the custom cache with one of the datatype generators
  // provided in this case a BoolGenerator
  test('Boolean', () async {
    // Run all the tests for a store
    await testStoreWith<CustomStore>(newStore, BoolGenerator(), deleteStore);
    // Run all the test for a cache
    await testCacheWith<CustomStore>(
        newStore, newCache, BoolGenerator(), deleteStore);
  });
  ...

```

Please take a look at the examples provided on one of the storage implementations, for example [stash_disk](https://github.com/ivoleitao/stash_disk) or [stash_moor](https://github.com/ivoleitao/stash_moor).

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details