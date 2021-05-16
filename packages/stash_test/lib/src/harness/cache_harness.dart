import 'package:clock/clock.dart';
import 'package:matcher/matcher.dart';
import 'package:stash/stash.dart';

import 'harness.dart';

/// Calls [Cache.put] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePut<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
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
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  var size = await cache.size;
  check(ctx, size, 1, '_cachePutRemove_1');

  await cache.remove('key_1');
  size = await cache.size;
  check(ctx, size, 0, '_cachePutRemove_2');

  return store;
}

/// Calls [Cache.size] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheSize<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  var size = await cache.size;
  check(ctx, size, 1, '_cacheSize_1');

  await cache.put('key_2', ctx.generator.nextValue(2));
  size = await cache.size;
  check(ctx, size, 2, '_cacheSize_2');

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  check(ctx, size, 3, '_cacheSize_3');

  await cache.remove('key_1');
  size = await cache.size;
  check(ctx, size, 2, '_cacheSize_4');

  await cache.remove('key_2');
  size = await cache.size;
  check(ctx, size, 1, '_cacheSize_5');

  await cache.remove('key_3');
  size = await cache.size;
  check(ctx, size, 0, '_cacheSize_6');

  return store;
}

/// Calls [Cache.containsKey] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheContainsKey<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
  await cache.put(key, value);
  final hasKey = await cache.containsKey(key);

  check(ctx, hasKey, isTrue, '_cacheContainsKey_1');

  return store;
}

/// Calls [Cache.keys] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheKeys<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key1 = 'key_1';
  await cache.put(key1, ctx.generator.nextValue(1));

  final key2 = 'key_2';
  await cache.put(key2, ctx.generator.nextValue(2));

  final key3 = 'key_3';
  await cache.put(key3, ctx.generator.nextValue(3));

  final keys = await cache.keys;

  check(ctx, keys, containsAll([key1, key2, key3]), '_cacheKeys_1');

  return store;
}

/// Calls [Cache.put] followed by a [Cache.get] on a [Cache] backed by
/// the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutGet<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key1 = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key1, value1);
  var value2 = await cache.get(key1);

  check(ctx, value2, value1, '_cachePutGet_1');

  value1 = null;
  await cache.put(key1, value1);
  value2 = await cache.get(key1);

  check(ctx, value2, value1, '_cachePutGet_2');

  final key2 = 'key_2';
  final value3 = null;
  await cache.put(key2, value3);
  final value4 = await cache.get(key2);

  check(ctx, value4, value3, '_cachePutGet_3');

  return store;
}

/// Calls [Cache.put] followed by a operator call on
/// a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutGetOperator<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  final value2 = await cache[key];

  check(ctx, value2, value1, '_cachePutGetOperator_1');

  return store;
}

/// Calls [Cache.put] followed by a second [Cache.put] on a [Cache] backed by
/// the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutPut<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  var size = await cache.size;
  check(ctx, size, 1, '_cachePutPut_1');
  var value2 = await cache.get(key);
  check(ctx, value2, value1, '_cachePutPut_2');

  value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  size = await cache.size;
  check(ctx, size, 1, '_cachePutPut_3');
  value2 = await cache.get(key);
  check(ctx, value2, value1, '_cachePutPut_4');

  return store;
}

/// Calls [Cache.putIfAbsent] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePutIfAbsent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  var added = await cache.putIfAbsent(key, value1);
  check(ctx, added, isTrue, '_cachePutIfAbsent_1');
  var size = await cache.size;
  check(ctx, size, 1, '_cachePutIfAbsent_2');
  var value2 = await cache.get(key);
  check(ctx, value2, value1, '_cachePutIfAbsent_3');

  added = await cache.putIfAbsent(key, ctx.generator.nextValue(2));
  check(ctx, added, isFalse, '_cachePutIfAbsent_4');
  size = await cache.size;
  check(ctx, size, 1, '_cachePutIfAbsent_5');
  value2 = await cache.get(key);
  check(ctx, value2, value1, '_cachePutIfAbsent_6');

  return store;
}

/// Calls [Cache.getAndPut] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheGetAndPut<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  final value2 = await cache.get(key);
  check(ctx, value2, value1, '_cacheGetAndPut_1');

  final value3 = ctx.generator.nextValue(3);
  final value4 = await cache.getAndPut(key, value3);
  check(ctx, value4, value1, '_cacheGetAndPut_2');

  final value5 = await cache.get(key);
  check(ctx, value5, value3, '_cacheGetAndPut_3');

  return store;
}

/// Calls [Cache.getAndRemove] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheGetAndRemove<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  final value2 = await cache.get(key);
  check(ctx, value2, value1, '_cacheGetAndRemove_1');

  final value3 = await cache.getAndRemove(key);
  check(ctx, value3, value1, '_cacheGetAndRemove_2');

  final size = await cache.size;
  check(ctx, size, 0, '_cacheGetAndRemove_3');

  return store;
}

/// Calls [Cache.clear] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheClear<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store);

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  check(ctx, size, 3, '_cacheClear_1');

  await cache.clear();
  size = await cache.size;
  check(ctx, size, 0, '_cacheClear_2');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [CreatedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheCreatedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().now();

  var cache = ctx.newCache(store,
      expiryPolicy: const CreatedExpiryPolicy(Duration(minutes: 10)),
      clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheCreatedExpiry_1');

  now = Clock().fromNow(hours: 1);

  present = await cache.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheCreatedExpiry_2');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [AccessedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheAccessedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().fromNow(seconds: 1);

  var cache = ctx.newCache(store,
      expiryPolicy: const AccessedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheAccessedExpiry_1');

  now = Clock().fromNow(hours: 1);

  present = await cache.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheAccessedExpiry_2');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [ModifiedExpiryPolicy]
///
/// * [ctx]: The test context
//
/// Returns the created store
Future<T> _cacheModifiedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().now();

  final cache1 = ctx.newCache(store,
      expiryPolicy: const ModifiedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache1.put('key_1', ctx.generator.nextValue(1));
  var present = await cache1.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheModifiedExpiry_1');

  now = Clock().fromNow(minutes: 2);
  present = await cache1.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheModifiedExpiry_2');

  now = Clock().now();
  final cache2 = ctx.newCache(store,
      expiryPolicy: const ModifiedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache2.put('key_1', ctx.generator.nextValue(1));
  present = await cache2.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheModifiedExpiry_3');

  now = Clock().fromNow(seconds: 30);
  await cache2.put('key_1', ctx.generator.nextValue(2));
  now = Clock().fromNow(minutes: 1, seconds: 20);

  present = await cache2.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheModifiedExpiry_4');

  now = Clock().fromNow(minutes: 3);
  present = await cache2.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheModifiedExpiry_5');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [TouchedExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheTouchedExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().now();

  // The cache expires
  final cache1 = ctx.newCache(store,
      expiryPolicy: const TouchedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  await cache1.put('key_1', ctx.generator.nextValue(1));
  var present = await cache1.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheTouchedExpiry_1');

  now = Clock().fromNow(minutes: 2);
  present = await cache1.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheTouchedExpiry_2');

  // Check if the update of the cache increases the expiry time
  now = Clock().now();
  final cache2 = ctx.newCache(store,
      expiryPolicy: const TouchedExpiryPolicy(Duration(minutes: 1)),
      clock: Clock(() => now));

  // First add a cache entry during the expiry time, it should be there
  await cache2.put('key_1', ctx.generator.nextValue(1));
  now = Clock().fromNow(seconds: 30);
  present = await cache2.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheTouchedExpiry_3');

  // Then add another and move the clock to the next slot. It should be there as
  // well because the put added the expiry time
  now = Clock().fromNow(seconds: 45);
  await cache2.put('key_1', ctx.generator.nextValue(2));
  now = Clock().fromNow(minutes: 1, seconds: 30);
  present = await cache2.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheTouchedExpiry_4');

  // Move the time again but this time without generating any change. The cache
  // should expire
  now = Clock().fromNow(minutes: 3);
  present = await cache2.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheTouchedExpiry_5');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [EternalExpiryPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheEternalExpiry<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(seconds: 1);
  final store = await ctx.newStore();
  final cache = ctx.newCache(store,
      expiryPolicy: const EternalExpiryPolicy(), clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  var present = await cache.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheEternalExpiry_1');

  now = Clock().fromNow(days: 365);

  present = await cache.containsKey('key_1');
  check(ctx, present, isTrue, '_cacheEternalExpiry_2');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [CacheLoader]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLoader<T extends CacheStore>(TestContext<T> ctx) async {
  var now = Clock().fromNow(minutes: 10);
  final store = await ctx.newStore();

  final value2 = ctx.generator.nextValue(2);
  final cache = ctx.newCache(store,
      expiryPolicy: const AccessedExpiryPolicy(Duration(seconds: 0)),
      cacheLoader: (key) => Future.value(value2),
      clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  now = Clock().fromNow(minutes: 20);
  final value = await cache.get('key_1');
  check(ctx, value, equals(value2), '_cacheLoader_1');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [FifoEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheFifoEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store,
      maxEntries: 2, evictionPolicy: const FifoEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  var size = await cache.size;
  check(ctx, size, 2, '_cacheFifoEviction_1');

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  check(ctx, size, 2, '_cacheFifoEviction_2');

  final present = await cache.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheFifoEviction_3');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [FiloEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheFiloEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store,
      maxEntries: 2, evictionPolicy: const FiloEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  var size = await cache.size;
  check(ctx, size, 2, '_cacheFiloEviction_1');

  await cache.put('key_3', ctx.generator.nextValue(3));
  size = await cache.size;
  check(ctx, size, 2, '_cacheFiloEviction_2');

  final present = await cache.containsKey('key_3');
  check(ctx, present, isTrue, '_cacheFiloEviction_3');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [LruEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLruEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().now();
  final cache = ctx.newCache(store,
      maxEntries: 3,
      evictionPolicy: const LruEvictionPolicy(),
      clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  check(ctx, size, 3, '_cacheLruEviction_1');

  now = Clock().fromNow(minutes: 1);
  await cache.get('key_1');
  now = Clock().fromNow(minutes: 2);
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  check(ctx, size, 3, '_cacheLruEviction_2');

  final present = await cache.containsKey('key_2');
  check(ctx, present, isFalse, '_cacheLruEviction_3');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [MruEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheMruEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  var now = Clock().now();
  final cache = ctx.newCache(store,
      maxEntries: 3,
      evictionPolicy: const MruEvictionPolicy(),
      clock: Clock(() => now));

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  check(ctx, size, 3, '_cacheMruEviction_1');

  now = Clock().fromNow(minutes: 1);
  await cache.get('key_1');
  now = Clock().fromNow(minutes: 2);
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  check(ctx, size, 3, '_cacheMruEviction_2');

  final present = await cache.containsKey('key_3');
  check(ctx, present, isFalse, '_cacheMruEviction_3');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [LfuEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheLfuEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const LfuEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  check(ctx, size, 3, '_cacheLfuEviction_1');

  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_2');
  await cache.get('key_3');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  check(ctx, size, 3, '_cacheLfuEviction_2');

  final present = await cache.containsKey('key_2');
  check(ctx, present, isFalse, '_cacheLfuEviction_3');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [MfuEvictionPolicy]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheMfuEviction<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newCache(store,
      maxEntries: 3, evictionPolicy: const MfuEvictionPolicy());

  await cache.put('key_1', ctx.generator.nextValue(1));
  await cache.put('key_2', ctx.generator.nextValue(2));
  await cache.put('key_3', ctx.generator.nextValue(3));
  var size = await cache.size;
  check(ctx, size, 3, '_cacheLfuEviction_1');

  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_1');
  await cache.get('key_2');
  await cache.get('key_3');
  await cache.get('key_3');

  await cache.put('key_4', ctx.generator.nextValue(4));
  size = await cache.size;
  check(ctx, size, 3, '_cacheMfuEviction_2');

  final present = await cache.containsKey('key_1');
  check(ctx, present, isFalse, '_cacheMfuEviction_3');

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
Future<void> testCacheWith<T extends CacheStore>(TestContext<T> ctx) async {
  for (var test in _getCacheTests<T>()) {
    await test(ctx).then(ctx.deleteStore);
  }
}
