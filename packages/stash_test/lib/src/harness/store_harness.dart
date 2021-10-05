import 'package:enum_to_string/enum_to_string.dart';
import 'package:matcher/matcher.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import 'harness.dart';

/// The default store name
const _defaultStore = 'test';

/// The default type tests perfomed over a store
final _storeTypeTests = Map.unmodifiable(typeTests);

/// The supported cache tests
enum StoreTest {
  addEntry,
  addGetEntry,
  removeEntry,
  size,
  clear,
  delete,
  getStat,
  changeEntry,
  keys,
  getValues,
  stats
}

/// The set of store tests
const _storeTests = {
  StoreTest.addEntry,
  StoreTest.addGetEntry,
  StoreTest.removeEntry,
  StoreTest.size,
  StoreTest.clear,
  StoreTest.delete,
  StoreTest.getStat,
  StoreTest.changeEntry,
  StoreTest.keys,
  StoreTest.getValues,
  StoreTest.stats
};

/// Calls [Store.size] with a optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling size on the provided [Store]
Future<int> _size<S extends Stat, E extends Entry<S>>(Store<S, E> store,
    {String name = _defaultStore}) {
  return store.size(name);
}

/// Calls [Store.containsKey] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling containsKey on the provided [Store]
Future<bool> _containsKey<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, String key,
    {String name = _defaultStore}) {
  return store.containsKey(name, key);
}

/// Calls [Store.getStat] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling getStat on the provided [Store]
Future<S?> _getStat<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, String key,
    {String name = _defaultStore}) {
  return store.getStat(name, key);
}

/// Calls [Store.getEntry] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling getEntry on the provided [Store]
Future<E?> _getEntry<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, String key,
    {String name = _defaultStore}) {
  return store.getEntry(name, key);
}

/// Calls [Store.putEntry] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [entry]: The [Entry] to store
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _putEntry<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, String key, E entry,
    {String name = _defaultStore}) {
  return store.putEntry(name, key, entry);
}

/// Calls [Store.putEntry] with an optional store name
///
/// * [store]: The [Store]
/// * [generator]: The [ValueGenerator] to use
/// * [seed]: The seed for the [ValueGenerator]
/// * [name]: An optional store name, assigned a default value if not provided
/// * [key]: The store key
/// * [expiryTime]: The cache expiry time
/// * [creationTime]: The cache creation time
/// * [accessTime]: The cache accessTime
/// * [updateTime]: The cache update time
/// * [hitCount]: The cache hit count
///
/// Returns the created [Entry]
Future<E> _putGetEntry<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, EntryBuilder<S, E> builder, int seed,
    {String name = _defaultStore,
    String? key,
    DateTime? creationTime,
    DateTime? accessTime,
    DateTime? updateTime}) async {
  final entry = builder.newEntry(seed,
      key: key,
      creationTime: creationTime,
      accessTime: accessTime,
      updateTime: updateTime);
  return _putEntry<S, E>(store, entry.key, entry, name: name)
      .then((v) => entry);
}

/// Calls [Store.remove] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _remove<S extends Stat, E extends Entry<S>>(
    Store<S, E> store, String key,
    {String name = _defaultStore}) {
  return store.remove(name, key);
}

/// Calls [Store.keys] with an optional cache name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling keys on the provided [Store]
Future<Iterable<String>> _keys<S extends Stat, E extends Entry<S>>(
    Store<S, E> store,
    {String name = _defaultStore}) {
  return store.keys(name);
}

/// Calls [Store.stats] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling stats on the provided [Store]
Future<Iterable<S?>> _stats<S extends Stat, E extends Entry<S>>(
    Store<S, E> store,
    {String name = _defaultStore}) {
  return store.stats(name);
}

/// Calls [Store.values] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling values on the provided [Store]
Future<Iterable<E?>> _values<S extends Stat, E extends Entry<S>>(
    Store<S, E> store,
    {String name = _defaultStore}) {
  return store.values(name);
}

/// Calls [Store.clear] with an optional cache name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _clear<S extends Stat, E extends Entry<S>>(Store<S, E> store,
    {String name = _defaultStore}) {
  return store.clear(name);
}

/// Calls [Store.delete] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _delete<S extends Stat, E extends Entry<S>>(Store<S, E> store,
    {String name = _defaultStore}) {
  return store.delete(name);
}

/// Test that adds a new entry on the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeAddEntry<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry = await _putGetEntry(store, ctx, 1);
  final hasEntry = await _containsKey(store, entry.key);
  check(ctx, hasEntry, isTrue, '_storeAddEntry_1');

  return store;
}

/// Test that adds and fetches a entry from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeAddGetEntry<S extends Stat, E extends Entry<S>,
    T extends Store<S, E>>(TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _getEntry(store, entry1.key);

  check(ctx, entry2, entry1, '_storeAddGetEntry_1');

  return store;
}

/// Test that removes a entry from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeRemoveEntry<S extends Stat, E extends Entry<S>,
    T extends Store<S, E>>(TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  var hasEntry = await _containsKey(store, entry1.key);
  check(ctx, hasEntry, isTrue, '_storeRemoveEntry_1');

  await _remove(store, entry1.key);
  hasEntry = await _containsKey(store, entry1.key);
  check(ctx, hasEntry, isFalse, '_storeRemoveEntry_2');

  return store;
}

/// Test that gets the size of the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeSize<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
    TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  var size = await _size(store);
  check(ctx, size, 0, '_storeSize_1');

  final entry1 = await _putGetEntry(store, ctx, 1);
  size = await _size(store);
  check(ctx, size, 1, '_storeSize_2');

  final entry2 = await _putGetEntry(store, ctx, 2);
  size = await _size(store);
  check(ctx, size, 2, '_storeSize_3');

  await _remove(store, entry1.key);
  size = await _size(store);
  check(ctx, size, 1, '_storeSize_4');

  await _remove(store, entry2.key);
  size = await _size(store);
  check(ctx, size, 0, '_storeSize_5');

  return store;
}

/// Test that clears the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeClear<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx, 1, name: 'cache1');
  await _putGetEntry(store, ctx, 2, name: 'cache1');
  var size = await _size(store, name: 'cache1');
  check(ctx, size, 2, '_storeClear_1');

  await _putGetEntry(store, ctx, 1, name: 'cache2');
  await _putGetEntry(store, ctx, 2, name: 'cache2');
  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeClear_2');

  await _clear(store, name: 'cache1');
  size = await _size(store, name: 'cache1');
  check(ctx, size, 0, '_storeClear_3');

  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeClear_4');

  return store;
}

/// Test that deletes a store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeDelete<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx, 1, name: 'cache1');
  await _putGetEntry(store, ctx, 2, name: 'cache1');
  var size = await _size(store, name: 'cache1');
  check(ctx, size, 2, '_storeDelete_1');

  await _putGetEntry(store, ctx, 1, name: 'cache2');
  await _putGetEntry(store, ctx, 2, name: 'cache2');
  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeDelete_2');

  await _delete(store, name: 'cache1');
  size = await _size(store, name: 'cache1');
  check(ctx, size, 0, '_storeDelete_3');

  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeDelete_4');

  return store;
}

/// Test that gets the [Stat] from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeGetStat<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry = await _putGetEntry(store, ctx, 1);
  final stat = await _getStat(store, entry.key);

  check(ctx, stat, isNotNull, '_storeGetStat_1');
  check(ctx, stat?.key, entry.key, '_storeGetStat_2');
  check(ctx, stat?.creationTime, entry.creationTime, '_storeGetStat_3');
  check(ctx, stat?.accessTime, entry.accessTime, '_storeGetStat_4');
  check(ctx, stat?.updateTime, entry.updateTime, '_storeGetStat_5');

  return store;
}

/// Test that changes a store entry
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeChangeEntry<S extends Stat, E extends Entry<S>,
    T extends Store<S, E>>(TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);

  final oldAccessTime = entry1.accessTime;
  entry1.accessTime = 1.minutes.fromNow;
  await _putEntry(store, entry1.key, entry1);

  final entry2 = await _getEntry(store, entry1.key);
  check(ctx, entry2?.creationTime, equals(entry1.creationTime),
      '_storeChangeEntry_1');
  check(ctx, entry2?.accessTime, isNot(equals(oldAccessTime)),
      '_storeChangeEntry_2');
  check(ctx, entry2?.accessTime, equals(entry1.accessTime),
      '_storeChangeEntry_3');
  check(ctx, entry2?.updateTime, equals(entry1.updateTime),
      '_storeChangeEntry_4');

  return store;
}

/// Test that retrieves the keys from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeKeys<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
    TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _putGetEntry(store, ctx, 2);
  final keys = await _keys(store);

  check(ctx, keys, containsAll([entry1.key, entry2.key]), '_storeKeys_1');

  return store;
}

/// Test that retrieves the values from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeValues<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _putGetEntry(store, ctx, 2);
  final values = await _values(store);

  check(ctx, values, containsAll([entry1, entry2]), '_storeValues_1');

  return store;
}

/// Test that retrieves the stats from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeStats<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _putGetEntry(store, ctx, 2);
  final stats = await _stats(store);

  check(ctx, stats, containsAll([entry1.stat, entry2.stat]), '_storeStats_1');

  return store;
}

/// Returns the list of tests to execute
///
/// * [tests]: The set of tests
List<
    Future<T> Function<S extends Stat, E extends Entry<S>,
        T extends Store<S, E>>(TestContext<S, E, T>)> _getTests<S, E, T>(
    {Set<StoreTest> tests = _storeTests}) {
  return [
    if (tests.contains(StoreTest.addEntry)) _storeAddEntry,
    if (tests.contains(StoreTest.addGetEntry)) _storeAddGetEntry,
    if (tests.contains(StoreTest.removeEntry)) _storeRemoveEntry,
    if (tests.contains(StoreTest.size)) _storeSize,
    if (tests.contains(StoreTest.clear)) _storeClear,
    if (tests.contains(StoreTest.delete)) _storeDelete,
    if (tests.contains(StoreTest.getStat)) _storeGetStat,
    if (tests.contains(StoreTest.changeEntry)) _storeChangeEntry,
    if (tests.contains(StoreTest.keys)) _storeKeys,
    if (tests.contains(StoreTest.getValues)) _storeValues,
    if (tests.contains(StoreTest.stats)) _storeStats
  ];
}

/// Entry point for the store testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the
/// [Store] creation, and the generation of testing values (with a provided
/// [ValueGenerator] instance). They are encapsulated in provided [TestContext] object
///
/// * [ctx]: the test context
/// * [tests]: The set of tests
Future<void>
    testStoreWith<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
        TestContext<S, E, T> ctx,
        {Set<StoreTest> tests = _storeTests}) async {
  for (var test in _getTests<S, E, T>()) {
    await test(ctx).then(ctx.deleteStore);
  }
}

/// Default store test
///
/// * [newTestContext]: The context builder
/// * [types]: The type/generator map
/// * [tests]: The test set
void testStore<S extends Stat, E extends Entry<S>, T extends Store<S, E>>(
    TestContextBuilder<S, E, T> newTestContext,
    {Map<TypeTest, Function>? types,
    Set<StoreTest> tests = _storeTests}) {
  for (var entry in (types ?? _storeTypeTests).entries) {
    test('Store: ${EnumToString.convertToString(entry.key)}', () async {
      await testStoreWith<S, E, T>(newTestContext(entry.value()), tests: tests);
    });
  }
}
