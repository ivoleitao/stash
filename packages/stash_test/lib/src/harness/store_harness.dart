import 'package:enum_to_string/enum_to_string.dart';
import 'package:matcher/matcher.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import 'harness.dart';

/// The default store name
const _defaultStore = 'test';

/// The default type tests perfomed over a store
final _storeTypeTests = Map.unmodifiable(defaultStoreTypeTests);

/// The supported store tests
enum StoreTest {
  addEntry,
  addGetEntry,
  removeEntry,
  size,
  clear,
  delete,
  getInfo,
  changeEntry,
  keys,
  getValues,
  infos
}

/// The set of store tests
const _storeTests = {
  StoreTest.addEntry,
  StoreTest.addGetEntry,
  StoreTest.removeEntry,
  StoreTest.size,
  StoreTest.clear,
  StoreTest.delete,
  StoreTest.getInfo,
  StoreTest.changeEntry,
  StoreTest.keys,
  StoreTest.getValues,
  StoreTest.infos
};

/// Calls [Store.size] with a optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling size on the provided [Store]
Future<int> _size<I extends Info, E extends Entry<I>>(Store<I, E> store,
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
Future<bool> _containsKey<I extends Info, E extends Entry<I>>(
    Store<I, E> store, String key,
    {String name = _defaultStore}) {
  return store.containsKey(name, key);
}

/// Calls [Store.getInfo] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling getInfo on the provided [Store]
Future<I?> _getInfo<I extends Info, E extends Entry<I>>(
    Store<I, E> store, String key,
    {String name = _defaultStore}) {
  return store.getInfo(name, key);
}

/// Calls [Store.getEntry] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling getEntry on the provided [Store]
Future<E?> _getEntry<I extends Info, E extends Entry<I>>(
    Store<I, E> store, String key,
    {String name = _defaultStore}) {
  return store.getEntry(name, key);
}

/// Calls [Store.putEntry] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [entry]: The [Entry] to store
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _putEntry<I extends Info, E extends Entry<I>>(
    Store<I, E> store, String key, E entry,
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
/// * [creationTime]: The entry creation time
/// * [accessTime]: The entry accessTime
/// * [updateTime]: The entry update time
///
/// Returns the created [Entry]
Future<E> _putGetEntry<I extends Info, E extends Entry<I>>(
    Store<I, E> store, EntryBuilder<I, E> builder, int seed,
    {String name = _defaultStore, String? key, DateTime? creationTime}) async {
  final entry = builder.newEntry(seed, key: key, creationTime: creationTime);
  return _putEntry<I, E>(store, entry.key, entry, name: name)
      .then((v) => entry);
}

/// Calls [Store.remove] with an optional store name
///
/// * [store]: The [Store]
/// * [key]: The store key
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _remove<I extends Info, E extends Entry<I>>(
    Store<I, E> store, String key,
    {String name = _defaultStore}) {
  return store.remove(name, key);
}

/// Calls [Store.keys] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling keys on the provided [Store]
Future<Iterable<String>> _keys<I extends Info, E extends Entry<I>>(
    Store<I, E> store,
    {String name = _defaultStore}) {
  return store.keys(name);
}

/// Calls [Store.infos] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling infos on the provided [Store]
Future<Iterable<I?>> _infos<I extends Info, E extends Entry<I>>(
    Store<I, E> store,
    {String name = _defaultStore}) {
  return store.infos(name);
}

/// Calls [Store.values] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
///
/// Returns the result of calling values on the provided [Store]
Future<Iterable<E?>> _values<I extends Info, E extends Entry<I>>(
    Store<I, E> store,
    {String name = _defaultStore}) {
  return store.values(name);
}

/// Calls [Store.clear] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _clear<I extends Info, E extends Entry<I>>(Store<I, E> store,
    {String name = _defaultStore}) {
  return store.clear(name);
}

/// Calls [Store.delete] with an optional store name
///
/// * [store]: The [Store]
/// * [name]: An optional store name, assigned a default value if not provided
Future<void> _delete<I extends Info, E extends Entry<I>>(Store<I, E> store,
    {String name = _defaultStore}) {
  return store.delete(name);
}

/// Test that adds a new entry on the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeAddEntry<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
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
Future<T> _storeAddGetEntry<I extends Info, E extends Entry<I>,
    T extends Store<I, E>>(TestContext<I, E, T> ctx) async {
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
Future<T> _storeRemoveEntry<I extends Info, E extends Entry<I>,
    T extends Store<I, E>>(TestContext<I, E, T> ctx) async {
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
Future<T> _storeSize<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
    TestContext<I, E, T> ctx) async {
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
    _storeClear<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx, 1, name: 'entry1');
  await _putGetEntry(store, ctx, 2, name: 'entry1');
  var size = await _size(store, name: 'entry1');
  check(ctx, size, 2, '_storeClear_1');

  await _putGetEntry(store, ctx, 1, name: 'entry2');
  await _putGetEntry(store, ctx, 2, name: 'entry2');
  size = await _size(store, name: 'entry2');
  check(ctx, size, 2, '_storeClear_2');

  await _clear(store, name: 'entry1');
  size = await _size(store, name: 'entry1');
  check(ctx, size, 0, '_storeClear_3');

  size = await _size(store, name: 'entry2');
  check(ctx, size, 2, '_storeClear_4');

  return store;
}

/// Test that deletes a store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeDelete<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx, 1, name: 'entry1');
  await _putGetEntry(store, ctx, 2, name: 'entry1');
  var size = await _size(store, name: 'entry1');
  check(ctx, size, 2, '_storeDelete_1');

  await _putGetEntry(store, ctx, 1, name: 'entry2');
  await _putGetEntry(store, ctx, 2, name: 'entry2');
  size = await _size(store, name: 'entry2');
  check(ctx, size, 2, '_storeDelete_2');

  await _delete(store, name: 'entry1');
  size = await _size(store, name: 'entry1');
  check(ctx, size, 0, '_storeDelete_3');

  size = await _size(store, name: 'entry2');
  check(ctx, size, 2, '_storeDelete_4');

  return store;
}

/// Test that gets the [Info] from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeGetInfo<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry = await _putGetEntry(store, ctx, 1);
  final info = await _getInfo(store, entry.key);

  check(ctx, info, isNotNull, '_storeGetInfo_1');
  check(ctx, info?.key, entry.key, '_storeGetInfo_2');
  check(ctx, info?.creationTime, entry.creationTime, '_storeGetInfo_3');
  check(ctx, info?.accessTime, entry.accessTime, '_storeGetInfo_4');
  check(ctx, info?.updateTime, entry.updateTime, '_storeGetInfo_5');

  return store;
}

/// Test that changes a store entry
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeChangeEntry<I extends Info, E extends Entry<I>,
    T extends Store<I, E>>(TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);

  final oldAccessTime = entry1.accessTime;
  entry1.updateInfoFields(accessTime: 1.minutes.fromNow);
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
Future<T> _storeKeys<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
    TestContext<I, E, T> ctx) async {
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
    _storeValues<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _putGetEntry(store, ctx, 2);
  final values = await _values(store);

  check(ctx, values, containsAll([entry1, entry2]), '_storeValues_1');

  return store;
}

/// Test that retrieves the infos from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T>
    _storeInfos<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx, 1);
  final entry2 = await _putGetEntry(store, ctx, 2);
  final infos = await _infos(store);

  check(ctx, infos, containsAll([entry1.info, entry2.info]), '_storeInfos_1');

  return store;
}

/// Returns the list of tests to execute
///
/// * [tests]: The set of tests
List<
    Future<T> Function<I extends Info, E extends Entry<I>,
        T extends Store<I, E>>(TestContext<I, E, T>)> _getTests<I, E, T>(
    {Set<StoreTest> tests = _storeTests}) {
  return [
    if (tests.contains(StoreTest.addEntry)) _storeAddEntry,
    if (tests.contains(StoreTest.addGetEntry)) _storeAddGetEntry,
    if (tests.contains(StoreTest.removeEntry)) _storeRemoveEntry,
    if (tests.contains(StoreTest.size)) _storeSize,
    if (tests.contains(StoreTest.clear)) _storeClear,
    if (tests.contains(StoreTest.delete)) _storeDelete,
    if (tests.contains(StoreTest.getInfo)) _storeGetInfo,
    if (tests.contains(StoreTest.changeEntry)) _storeChangeEntry,
    if (tests.contains(StoreTest.keys)) _storeKeys,
    if (tests.contains(StoreTest.getValues)) _storeValues,
    if (tests.contains(StoreTest.infos)) _storeInfos
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
    testStoreWith<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
        TestContext<I, E, T> ctx,
        {Set<StoreTest> tests = _storeTests}) async {
  for (var test in _getTests<I, E, T>()) {
    await test(ctx).then(ctx.deleteStore);
  }
}

/// Default store test
///
/// * [newTestContext]: The context builder
/// * [types]: The type/generator map
/// * [tests]: The test set
void testStore<I extends Info, E extends Entry<I>, T extends Store<I, E>>(
    TestContextBuilder<I, E, T> newTestContext,
    {Map<TypeTest, Function>? types,
    Set<StoreTest> tests = _storeTests}) {
  for (var entry in (types ?? _storeTypeTests).entries) {
    test('Store: ${EnumToString.convertToString(entry.key)}', () async {
      await testStoreWith<I, E, T>(newTestContext(entry.value()), tests: tests);
    });
  }
}
