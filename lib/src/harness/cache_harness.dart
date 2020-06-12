import 'package:quiver/time.dart';
import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/api/eviction/fifo_policy.dart';
import 'package:stash/src/api/eviction/filo_policy.dart';
import 'package:stash/src/api/eviction/lfu_policy.dart';
import 'package:stash/src/api/eviction/lru_policy.dart';
import 'package:stash/src/api/eviction/mfu_policy.dart';
import 'package:stash/src/api/eviction/mru_policy.dart';
import 'package:stash/src/api/expiry/accessed_policy.dart';
import 'package:stash/src/api/expiry/created_policy.dart';
import 'package:stash/src/api/expiry/eternal_policy.dart';
import 'package:stash/src/api/expiry/modified_policy.dart';
import 'package:stash/src/api/expiry/touched_policy.dart';
import 'package:test/test.dart';

import 'harness.dart';

/// Calls [Cache.put] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePut<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value = ctx.generator.nextValue(1);
  await cache.put(key, value);

  return store;
}

/// Calls [Cache.put] on a [Cache] backed by the provided [CacheStore] builder
/// and removes the value through [Cache.remove]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutRemove<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  var size = await cache.size;
  expect(size, 1);

  await cache.remove('key_1');
  size = await cache.size;
  expect(size, 0);

  return store;
}

/// Calls [Cache.size] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheSize<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  var size = await cache.size;
  expect(size, 1);

  await cache.put('key_2', ctx.generator.nextValue(2));
  size = await cache.size;
  expect(size, 2);

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  expect(size, 3);

  await cache.remove('key_1');
  size = await cache.size;
  expect(size, 2);

  await cache.remove('key_2');
  size = await cache.size;
  expect(size, 1);

  await cache.remove('key_3');
  size = await cache.size;
  expect(size, 0);

  return store;
}

/// Calls [Cache.containsKey] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheContainsKey<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value = ctx.generator.nextValue(1);
  await cache.put(key, value);
  var hasKey = await cache.containsKey(key);

  expect(hasKey, isTrue);

  return store;
}

/// Calls [Cache.keys] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheKeys<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key1 = 'key_1';
  await cache.put(key1, ctx.generator.nextValue(1));

  var key2 = 'key_2';
  await cache.put(key2, ctx.generator.nextValue(2));

  var key3 = 'key_3';
  await cache.put(key3, ctx.generator.nextValue(3));

  var keys = await cache.keys;

  expect(keys, containsAll([key1, key2, key3]));

  return store;
}

/// Calls [Cache.put] followed by a [Cache.get] on a [Cache] backed by
/// the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutGet<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var value2 = await cache.get(key);

  expect(value2, value1);

  return store;
}

/// Calls [Cache.put] followed by a operator call on
/// a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutGetOperator<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var value2 = await cache[key];

  expect(value2, value1);

  return store;
}

/// Calls [Cache.put] followed by a second [Cache.put] on a [Cache] backed by
/// the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutPut<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var size = await cache.size;
  expect(size, 1);
  var value2 = await cache.get(key);
  expect(value2, value1);

  value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  size = await cache.size;
  expect(size, 1);
  value2 = await cache.get(key);
  expect(value2, value1);

  return store;
}

/// Calls [Cache.putIfAbsent] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutIfAbsent<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  var added = await cache.putIfAbsent(key, value1);
  expect(added, isTrue);
  var size = await cache.size;
  expect(size, 1);
  var value2 = await cache.get(key);
  expect(value2, value1);

  added = await cache.putIfAbsent(key, ctx.generator.nextValue(2));
  expect(added, isFalse);
  size = await cache.size;
  expect(size, 1);
  value2 = await cache.get(key);
  expect(value2, value1);

  return store;
}

/// Calls [Cache.getAndPut] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheGetAndPut<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var value2 = await cache.get(key);
  expect(value2, value1);

  var value3 = ctx.generator.nextValue(3);
  var value4 = await cache.getAndPut(key, value3);
  expect(value4, value1);

  var value5 = await cache.get(key);
  expect(value5, value3);

  return store;
}

/// Calls [Cache.getAndRemove] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheGetAndRemove<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  var key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var value2 = await cache.get(key);
  expect(value2, value1);

  var value3 = await cache.getAndRemove(key);
  expect(value3, value1);

  var size = await cache.size;
  expect(size, 0);

  return store;
}

/// Calls [Cache.clear] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheClear<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  expect(size, 3);

  await cache.clear();
  size = await cache.size;
  expect(size, 0);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [CreatedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheCreatedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      expiryPolicy: const CreatedExpiryPolicy(Duration(microseconds: 0)));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [AccessedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheAccessedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(microseconds: 1);
  var store = await ctx.newStore();

  var cache = ctx.newCache(store,
      expiryPolicy: const AccessedExpiryPolicy(Duration(microseconds: 0)));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  expect(present, isFalse);

  var cache2 = ctx.newCache(store,
      expiryPolicy: const AccessedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache2.put('key_1', ctx.generator.nextValue(1));
  present = await cache2.containsKey('key_1');
  expect(present, isTrue);

  now = Clock().fromNow(hours: 1);

  present = await cache2.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [ModifiedExpiryPolicy]
///
/// * [ctx]: The test context
//
/// Returns the created store
Future<T> _cacheModifiedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(microseconds: 1);
  var store = await ctx.newStore();

  var cache1 = ctx.newCache(store,
      expiryPolicy: const ModifiedExpiryPolicy(Duration(microseconds: 0)));

  await cache1.put('key_1', ctx.generator.nextValue(1));
  var present = await cache1.containsKey('key_1');
  expect(present, isFalse);

  var cache2 = ctx.newCache(store,
      expiryPolicy: const ModifiedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache2.put('key_1', ctx.generator.nextValue(1));
  present = await cache2.containsKey('key_1');
  expect(present, isTrue);

  now = Clock().fromNow(minutes: 2);

  present = await cache2.containsKey('key_1');
  expect(present, isFalse);

  var cache3 = ctx.newCache(store,
      expiryPolicy: const ModifiedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache3.put('key_1', ctx.generator.nextValue(1));
  present = await cache3.containsKey('key_1');
  expect(present, isTrue);

  await cache3.put('key_1', ctx.generator.nextValue(2));
  now = Clock().fromNow(minutes: 2);

  present = await cache3.containsKey('key_1');
  expect(present, isTrue);

  now = Clock().fromNow(minutes: 3);
  present = await cache3.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [TouchedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheTouchedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(microseconds: 1);
  var store = await ctx.newStore();

  // The expiry policy works on creation of the cache
  var cache = ctx.newCache(store,
      expiryPolicy: const TouchedExpiryPolicy(Duration(microseconds: 0)));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  expect(present, isFalse);

  // The cache expires
  var cache2 = ctx.newCache(store,
      expiryPolicy: const TouchedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache2.put('key_1', ctx.generator.nextValue(1));
  present = await cache2.containsKey('key_1');
  expect(present, isTrue);

  now = Clock().fromNow(minutes: 2);
  present = await cache2.containsKey('key_1');
  expect(present, isFalse);

  // Check if the updated of the cache increases the expiry time
  var cache3 = ctx.newCache(store,
      expiryPolicy: const TouchedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  // First add a cache entry during the 1 minute time, it should be there
  await cache3.put('key_1', ctx.generator.nextValue(1));
  present = await cache3.containsKey('key_1');
  expect(present, isTrue);

  // Then add another and move the clock to the next slot. It should be there as
  // well because the put added 1 minute
  await cache3.put('key_1', ctx.generator.nextValue(2));
  now = Clock().fromNow(minutes: 2);
  present = await cache3.containsKey('key_1');
  expect(present, isTrue);

  // Move the time again but this time without generating any change. The cache
  // should expire
  now = Clock().fromNow(minutes: 3);
  present = await cache3.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [EternalExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheEternalExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(microseconds: 1);
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      expiryPolicy: const EternalExpiryPolicy(), clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  expect(present, isTrue);

  now = Clock().fromNow(days: 99999);

  present = await cache.containsKey('key_1');
  expect(present, isTrue);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [CacheLoader]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLoader<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();

  var value2 = ctx.generator.nextValue(2);
  var cache = ctx.newCache(store,
      expiryPolicy: const AccessedExpiryPolicy(Duration(microseconds: 0)),
      cacheLoader: (key) => Future.value(value2));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var value = await cache.get('key_1');
  expect(value, equals(value2));

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [FifoEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheFifoEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 2, evictionPolicy: const FifoEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  var size = await cache.size;
  expect(size, 2);

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  expect(size, 2);

  var present = await cache.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [FiloEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheFiloEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 2, evictionPolicy: const FiloEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  var size = await cache.size;
  expect(size, 2);

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  expect(size, 2);

  var present = await cache.containsKey('key_3');
  expect(present, isTrue);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [LruEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLruEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const LruEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  expect(size, 3);

  await cache.get('key_1');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  expect(size, 3);

  var present = await cache.containsKey('key_2');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [MruEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheMruEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const MruEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  expect(size, 3);

  await cache.get('key_1');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  expect(size, 3);

  var present = await cache.containsKey('key_3');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [LfuEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLfuEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const LfuEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  expect(size, 3);

  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_2');
  await cache.get('key_3');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  expect(size, 3);

  var present = await cache.containsKey('key_2');
  expect(present, isFalse);

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [MfuEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheMfuEviction<T extends CacheStore>(TestContext<T> ctx) async {
  var store = await ctx.newStore();
  var cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const MfuEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  expect(size, 3);

  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_2');
  await cache.get('key_3');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  expect(size, 3);

  var present = await cache.containsKey('key_1');
  expect(present, isFalse);

  return store;
}

/// returns the list of tests to execute
List<Future<T> Function(TestContext<T>)>
    _getCacheTests<T extends CacheStore>() {
  return [
    _cachePut,
    _cachePutRemove,
    _cacheSize,
    _cacheContainsKey,
    _cacheKeys,
    _cachePutGet,
    _cachePutGetOperator,
    _cachePutPut,
    _cachePutIfAbsent,
    _cacheGetAndPut,
    _cacheGetAndRemove,
    _cacheClear,
    _cacheCreatedExpiry,
    _cacheAccessedExpiry,
    _cacheModifiedExpiry,
    _cacheTouchedExpiry,
    _cacheEternalExpiry,
    _cacheLoader,
    _cacheFifoEviction,
    _cacheFiloEviction,
    _cacheLruEviction,
    _cacheMruEviction,
    _cacheLfuEviction,
    _cacheMfuEviction
  ];
}

/// Entry point for the cache testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the [CacheStore] creation,
/// the [Cache] creation and by the generation of testing values
/// (with a provided [ValueGenerator] instance). They are encapsulated in provided [TestContext] object
///
/// * [ctx]: the test context
void testCacheWith<T extends CacheStore>(TestContext<T> ctx) async {
  for (var test in _getCacheTests<T>()) {
    await test(ctx).then(ctx.deleteStore);
  }
}
