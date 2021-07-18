import 'package:clock/clock.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:matcher/matcher.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';

import 'harness.dart';

/// The default type tests perfomed over a cache
final _typeTests = Map.unmodifiable(typeTests);

/// The supported cache tests
enum CacheTest {
  put,
  putRemove,
  size,
  containsKey,
  keys,
  putGet,
  putGetOperator,
  putPut,
  putIfAbsent,
  getAndPut,
  getAndRemove,
  clear,
  createdExpiry,
  accessedExpiry,
  modifiedExpiry,
  touchedExpiry,
  eternalExpiry,
  loader,
  fifoEviction,
  filoEviction,
  lruEviction,
  mruEviction,
  lfuEviction,
  mfuEviction,
  createdEvent,
  updatedEvent,
  removedEvent,
  expiredEvent,
  evictedEvent
}

/// The set of cache tests
const _cacheTests = {
  CacheTest.put,
  CacheTest.putRemove,
  CacheTest.size,
  CacheTest.containsKey,
  CacheTest.keys,
  CacheTest.putGet,
  CacheTest.putGetOperator,
  CacheTest.putPut,
  CacheTest.putIfAbsent,
  CacheTest.getAndPut,
  CacheTest.getAndRemove,
  CacheTest.clear,
  CacheTest.createdExpiry,
  CacheTest.accessedExpiry,
  CacheTest.modifiedExpiry,
  CacheTest.touchedExpiry,
  CacheTest.eternalExpiry,
  CacheTest.loader,
  CacheTest.fifoEviction,
  CacheTest.filoEviction,
  CacheTest.lruEviction,
  CacheTest.mruEviction,
  CacheTest.lfuEviction,
  CacheTest.mfuEviction,
  CacheTest.createdEvent,
  CacheTest.updatedEvent,
  CacheTest.removedEvent,
  CacheTest.expiredEvent,
  CacheTest.evictedEvent
};

/// Calls [Cache.put] on a [Cache] backed by the provided [CacheStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cachePut<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  CacheEvent? created;
  final cache = ctx.newCache(store,
      eventListenerMode: EventListenerMode.synchronous)
    ..on().listen((event) => created = event);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
  await cache.put(key, value);
  check(ctx, created, isNotNull, '_cachePut_1');
  check(ctx, created, isA<CreatedEntryEvent>(), '_cachePut_2');

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
  var createdEntries = 0;
  var updatedEntries = 0;
  final cache = ctx.newCache(store,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen((event) => createdEntries++)
    ..on<UpdatedEntryEvent>().listen((event) => updatedEntries++);

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

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [CreatedEntryEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheCreatedEvent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final clock1 = Clock.fixed(now1);
  const expireDuration = ExpiryPolicy.eternal;
  final expiryTime = clock1.fromNowBy(expireDuration);
  var clock = clock1;
  CreatedEntryEvent? created;
  final cache = ctx.newCache(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<CreatedEntryEvent>().listen((event) => created = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_cacheCreatedEvent_1');
  check(ctx, created?.source, cache, '_cacheCreatedEvent_2');
  check(ctx, created?.type, EntryEventType.created, '_cacheCreatedEvent_3');
  check(ctx, created?.entry.key, key, '_cacheCreatedEvent_4');
  check(ctx, created?.entry.value, value1, '_cacheCreatedEvent_5');
  check(ctx, created?.entry.expiryTime, expiryTime, '_cacheCreatedEvent_6');
  check(ctx, created?.entry.creationTime, clock.now(), '_cacheCreatedEvent_7');
  check(ctx, created?.entry.accessTime, clock.now(), '_cacheCreatedEvent_8');
  check(ctx, created?.entry.updateTime, clock.now(), '_cacheCreatedEvent_9');
  check(ctx, created?.entry.hitCount, 0, '_cacheCreatedEvent_10');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [UpdatedEntryEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheUpdatedEvent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now2 = Clock().minutesFromNow(1);
  final now3 = Clock().minutesFromNow(3);
  final now4 = Clock().minutesFromNow(5);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now2);
  final clock3 = Clock.fixed(now3);
  final clock4 = Clock.fixed(now4);
  const eternalDuration = ExpiryPolicy.eternal;
  final shorterDuration = Duration(days: 30);
  final expiryTime1 = clock1.fromNowBy(eternalDuration);
  final expiryTime2 = clock2.fromNowBy(eternalDuration);
  final expiryTime3 = clock3.fromNowBy(shorterDuration);
  final expiryTime4 = clock4.fromNowBy(eternalDuration);
  var clock = clock1;
  CreatedEntryEvent? created;
  UpdatedEntryEvent? updated;
  final cache = ctx.newCache(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<CreatedEntryEvent>().listen((event) => created = event)
    ..on<UpdatedEntryEvent>().listen((event) => updated = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_cacheUpdatedEvent_1');
  check(ctx, created?.source, cache, '_cacheUpdatedEvent_2');
  check(ctx, created?.type, EntryEventType.created, '_cacheUpdatedEvent_3');
  check(ctx, created?.entry.key, key, '_cacheUpdatedEvent_4');
  check(ctx, created?.entry.value, value1, '_cacheUpdatedEvent_5');
  check(ctx, created?.entry.expiryTime, expiryTime1, '_cacheUpdatedEvent_6');
  check(ctx, created?.entry.creationTime, clock.now(), '_cacheUpdatedEvent_7');
  check(ctx, created?.entry.accessTime, clock.now(), '_cacheUpdatedEvent_8');
  check(ctx, created?.entry.updateTime, clock.now(), '_cacheUpdatedEvent_9');
  check(ctx, created?.entry.hitCount, 0, '_cacheUpdatedEvent_10');

  clock = clock2;
  final value2 = ctx.generator.nextValue(2);
  await cache.put(key, value2);
  check(ctx, updated, isNotNull, '_cacheUpdatedEvent_11');
  check(ctx, updated?.source, cache, '_cacheUpdatedEvent_12');
  check(ctx, updated?.type, EntryEventType.updated, '_cacheUpdatedEvent_13');
  check(ctx, updated?.oldEntry.key, key, '_cacheUpdatedEvent_14');
  check(ctx, updated?.oldEntry.value, value1, '_cacheUpdatedEvent_15');
  check(
      ctx, updated?.oldEntry.expiryTime, expiryTime1, '_cacheUpdatedEvent_16');
  check(ctx, updated?.oldEntry.creationTime, clock1.now(),
      '_cacheUpdatedEvent_17');
  check(
      ctx, updated?.oldEntry.accessTime, clock1.now(), '_cacheUpdatedEvent_18');
  check(
      ctx, updated?.oldEntry.updateTime, clock1.now(), '_cacheUpdatedEvent_19');
  check(ctx, updated?.oldEntry.hitCount, 0, '_cacheUpdatedEvent_20');
  check(ctx, updated?.newEntry.key, key, '_cacheUpdatedEvent_21');
  check(ctx, updated?.newEntry.value, value2, '_cacheUpdatedEvent_22');
  check(
      ctx, updated?.newEntry.expiryTime, expiryTime2, '_cacheUpdatedEvent_23');
  check(ctx, updated?.newEntry.creationTime, clock1.now(),
      '_cacheUpdatedEvent_24');
  check(
      ctx, updated?.newEntry.accessTime, clock1.now(), '_cacheUpdatedEvent_25');
  check(
      ctx, updated?.newEntry.updateTime, clock2.now(), '_cacheUpdatedEvent_26');
  check(ctx, updated?.newEntry.hitCount, 1, '_cacheUpdatedEvent_27');

  clock = clock3;
  final value3 = ctx.generator.nextValue(3);
  await cache.put(key, value3, expiryDuration: shorterDuration);
  check(
      ctx, updated?.oldEntry.expiryTime, expiryTime2, '_cacheUpdatedEvent_27');
  check(
      ctx, updated?.newEntry.expiryTime, expiryTime3, '_cacheUpdatedEvent_28');

  clock = clock4;
  await cache.put(key, value3, expiryDuration: null);
  check(
      ctx, updated?.oldEntry.expiryTime, expiryTime3, '_cacheUpdatedEvent_27');
  check(
      ctx, updated?.newEntry.expiryTime, expiryTime4, '_cacheUpdatedEvent_28');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [RemovedEntryEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheRemovedEvent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now3 = Clock().minutesFromNow(3);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now3);
  const expireDuration = ExpiryPolicy.eternal;
  final expiryTime = clock1.fromNowBy(expireDuration);
  var clock = clock1;
  CreatedEntryEvent? created;
  RemovedEntryEvent? removed;
  final cache = ctx.newCache(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<CreatedEntryEvent>().listen((event) => created = event)
    ..on<RemovedEntryEvent>().listen((event) => removed = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_cacheRemovedEvent_1');
  check(ctx, created?.source, cache, '_cacheRemovedEvent_2');
  check(ctx, created?.type, EntryEventType.created, '_cacheRemovedEvent_3');
  check(ctx, created?.entry.key, key, '_cacheRemovedEvent_4');
  check(ctx, created?.entry.value, value1, '_cacheRemovedEvent_5');
  check(ctx, created?.entry.expiryTime, expiryTime, '_cacheRemovedEvent_6');
  check(ctx, created?.entry.creationTime, clock.now(), '_cacheRemovedEvent_7');
  check(ctx, created?.entry.accessTime, clock.now(), '_cacheRemovedEvent_8');
  check(ctx, created?.entry.updateTime, clock.now(), '_cacheRemovedEvent_9');
  check(ctx, created?.entry.hitCount, 0, '_cacheRemovedEvent_10');

  clock = clock2;
  await cache.remove(key);
  check(ctx, removed, isNotNull, '_cacheRemovedEvent_11');
  check(ctx, removed?.source, cache, '_cacheRemovedEvent_12');
  check(ctx, removed?.type, EntryEventType.removed, '_cacheRemovedEvent_13');
  check(ctx, removed?.entry.key, key, '_cacheRemovedEvent_14');
  check(ctx, removed?.entry.value, value1, '_cacheRemovedEvent_15');
  check(ctx, removed?.entry.expiryTime, expiryTime, '_cacheRemovedEvent_16');
  check(
      ctx, removed?.entry.creationTime, clock1.now(), '_cacheRemovedEvent_17');
  check(ctx, removed?.entry.accessTime, clock1.now(), '_cacheRemovedEvent_18');
  check(ctx, removed?.entry.updateTime, clock1.now(), '_cacheRemovedEvent_19');
  check(ctx, removed?.entry.hitCount, 0, '_cacheRemovedEvent_20');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [ExpiredEntryEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheExpiredEvent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now3 = Clock().minutesFromNow(3);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now3);
  const expireDuration = Duration(minutes: 2);
  final expiryTime = clock1.fromNowBy(expireDuration);
  var clock = clock1;
  CreatedEntryEvent? created;
  ExpiredEntryEvent? expired;
  final cache = ctx.newCache(store,
      expiryPolicy: const CreatedExpiryPolicy(expireDuration),
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<CreatedEntryEvent>().listen((event) => created = event)
    ..on<ExpiredEntryEvent>().listen((event) => expired = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_cacheExpiredEvent_1');
  check(ctx, created?.source, cache, '_cacheExpiredEvent_2');
  check(ctx, created?.type, EntryEventType.created, '_cacheExpiredEvent_3');
  check(ctx, created?.entry.key, key, '_cacheExpiredEvent_4');
  check(ctx, created?.entry.value, value1, '_cacheExpiredEvent_5');
  check(ctx, created?.entry.expiryTime, expiryTime, '_cacheExpiredEvent_6');
  check(ctx, created?.entry.creationTime, clock.now(), '_cacheExpiredEvent_7');
  check(ctx, created?.entry.accessTime, clock.now(), '_cacheExpiredEvent_8');
  check(ctx, created?.entry.updateTime, clock.now(), '_cacheExpiredEvent_9');
  check(ctx, created?.entry.hitCount, 0, '_cacheExpiredEvent_10');

  clock = clock2;
  final value2 = await cache.get(key);
  check(ctx, value2, isNull, '_cacheExpiredEvent_11');
  check(ctx, expired, isNotNull, '_cacheExpiredEvent_12');
  check(ctx, expired?.source, cache, '_cacheExpiredEvent_13');
  check(ctx, expired?.type, EntryEventType.expired, '_cacheExpiredEvent_14');
  check(ctx, expired?.entry.key, key, '_cacheExpiredEvent_15');
  check(ctx, expired?.entry.value, value1, '_cacheExpiredEvent_16');
  check(ctx, expired?.entry.expiryTime, expiryTime, '_cacheExpiredEvent_17');
  check(
      ctx, expired?.entry.creationTime, clock1.now(), '_cacheExpiredEvent_18');
  check(ctx, expired?.entry.accessTime, clock1.now(), '_cacheExpiredEvent_19');
  check(ctx, expired?.entry.updateTime, clock1.now(), '_cacheExpiredEvent_20');
  check(ctx, expired?.entry.hitCount, 0, '_cacheExpiredEvent_21');

  return store;
}

/// Builds a [Cache] backed by the provided [CacheStore] builder
/// configured with a [EvictdEntryEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _cacheEvictedEvent<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now2 = Clock().minutesFromNow(3);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now2);
  const expireDuration = ExpiryPolicy.eternal;
  final expiryTime = clock1.fromNowBy(expireDuration);
  var clock = clock1;
  CreatedEntryEvent? created;
  EvictedEntryEvent? evicted;
  final cache = ctx.newCache(store,
      maxEntries: 1,
      evictionPolicy: const FiloEvictionPolicy(),
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<CreatedEntryEvent>().listen((event) => created = event)
    ..on<EvictedEntryEvent>().listen((event) => evicted = event);

  final key1 = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key1, value1);
  check(ctx, created, isNotNull, '_cacheEvictedEvent_1');
  check(ctx, created?.source, cache, '_cacheEvictedEvent_2');
  check(ctx, created?.type, EntryEventType.created, '_cacheEvictedEvent_3');
  check(ctx, created?.entry.key, key1, '_cacheEvictedEvent_4');
  check(ctx, created?.entry.value, value1, '_cacheEvictedEvent_5');
  check(ctx, created?.entry.expiryTime, expiryTime, '_cacheEvictedEvent_6');
  check(ctx, created?.entry.creationTime, clock.now(), '_cacheEvictedEvent_7');
  check(ctx, created?.entry.accessTime, clock.now(), '_cacheEvictedEvent_8');
  check(ctx, created?.entry.updateTime, clock.now(), '_cacheEvictedEvent_9');
  check(ctx, created?.entry.hitCount, 0, '_cacheEvictedEvent_10');

  clock = clock2;
  final key2 = 'key_2';
  final value2 = ctx.generator.nextValue(2);
  await cache.put(key2, value2);
  check(ctx, evicted, isNotNull, '_cacheEvictedEvent_11');
  check(ctx, evicted?.source, cache, '_cacheEvictedEvent_12');
  check(ctx, evicted?.type, EntryEventType.evicted, '_cacheEvictedEvent_13');
  check(ctx, evicted?.entry.key, key1, '_cacheEvictedEvent_14');
  check(ctx, evicted?.entry.value, value1, '_cacheEvictedEvent_15');
  check(ctx, evicted?.entry.expiryTime, expiryTime, '_cacheEvictedEvent_16');
  check(
      ctx, evicted?.entry.creationTime, clock1.now(), '_cacheEvictedEvent_17');
  check(ctx, evicted?.entry.accessTime, clock1.now(), '_cacheEvictedEvent_18');
  check(ctx, evicted?.entry.updateTime, clock1.now(), '_cacheEvictedEvent_19');
  check(ctx, evicted?.entry.hitCount, 0, '_cacheEvictedEvent_20');

  return store;
}

/// Returns the list of tests to execute
///
/// * [tests]: The set of tests
List<Future<T> Function(TestContext<T>)> _getCacheTests<T extends CacheStore>(
    {Set<CacheTest> tests = _cacheTests}) {
  return [
    if (tests.contains(CacheTest.put)) _cachePut,
    if (tests.contains(CacheTest.putRemove)) _cachePutRemove,
    if (tests.contains(CacheTest.size)) _cacheSize,
    if (tests.contains(CacheTest.containsKey)) _cacheContainsKey,
    if (tests.contains(CacheTest.keys)) _cacheKeys,
    if (tests.contains(CacheTest.putGet)) _cachePutGet,
    if (tests.contains(CacheTest.putGetOperator)) _cachePutGetOperator,
    if (tests.contains(CacheTest.putPut)) _cachePutPut,
    if (tests.contains(CacheTest.putIfAbsent)) _cachePutIfAbsent,
    if (tests.contains(CacheTest.getAndPut)) _cacheGetAndPut,
    if (tests.contains(CacheTest.getAndRemove)) _cacheGetAndRemove,
    if (tests.contains(CacheTest.clear)) _cacheClear,
    if (tests.contains(CacheTest.createdExpiry)) _cacheCreatedExpiry,
    if (tests.contains(CacheTest.accessedExpiry)) _cacheAccessedExpiry,
    if (tests.contains(CacheTest.modifiedExpiry)) _cacheModifiedExpiry,
    if (tests.contains(CacheTest.touchedExpiry)) _cacheTouchedExpiry,
    if (tests.contains(CacheTest.eternalExpiry)) _cacheEternalExpiry,
    if (tests.contains(CacheTest.loader)) _cacheLoader,
    if (tests.contains(CacheTest.fifoEviction)) _cacheFifoEviction,
    if (tests.contains(CacheTest.filoEviction)) _cacheFiloEviction,
    if (tests.contains(CacheTest.lruEviction)) _cacheLruEviction,
    if (tests.contains(CacheTest.mruEviction)) _cacheMruEviction,
    if (tests.contains(CacheTest.lfuEviction)) _cacheLfuEviction,
    if (tests.contains(CacheTest.mfuEviction)) _cacheMfuEviction,
    if (tests.contains(CacheTest.createdEvent)) _cacheCreatedEvent,
    if (tests.contains(CacheTest.updatedEvent)) _cacheUpdatedEvent,
    if (tests.contains(CacheTest.removedEvent)) _cacheRemovedEvent,
    if (tests.contains(CacheTest.expiredEvent)) _cacheExpiredEvent,
    if (tests.contains(CacheTest.evictedEvent)) _cacheEvictedEvent
  ];
}

/// Entry point for the cache testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the [CacheStore] creation,
/// the [Cache] creation and by the generation of testing values
/// (with a provided [ValueGenerator] instance). They are encapsulated in provided [TestContext] object
///
/// * [ctx]: the test context
/// * [tests]: The set of tests
Future<void> testCacheWith<T extends CacheStore>(TestContext<T> ctx,
    {Set<CacheTest> tests = _cacheTests}) async {
  for (var test in _getCacheTests<T>(tests: tests)) {
    await test(ctx).then(ctx.deleteStore);
  }
}

/// Default cache test
///
/// * [newTestContext]: The context builder
/// * [types]: The type/generator map
/// * [tests]: The test set
void testCache<T extends CacheStore>(TestContextBuilder<T> newTestContext,
    {Map<TypeTest, Function>? types, Set<CacheTest> tests = _cacheTests}) {
  for (var entry in (types ?? _typeTests).entries) {
    test('Cache: ${EnumToString.convertToString(entry.key)}', () async {
      await testCacheWith<T>(newTestContext(entry.value()), tests: tests);
    });
  }
}
