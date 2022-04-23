import 'package:clock/clock.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_test/stash_test.dart';
import 'package:test/test.dart';

import 'harness.dart';

/// The default type tests performed over a vault
final _typeTests = Map<TypeTest, ValueGenerator Function()>.unmodifiable(
    defaultStashTypeTests);

/// The supported vault tests
enum VaultTest {
  name,
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
  remove,
  removeAll,
  createdEvent,
  updatedEvent,
  removedEvent,
  stats
}

/// The set of vault tests
const _vaultTests = {
  VaultTest.name,
  VaultTest.put,
  VaultTest.putRemove,
  VaultTest.size,
  VaultTest.containsKey,
  VaultTest.keys,
  VaultTest.putGet,
  VaultTest.putGetOperator,
  VaultTest.putPut,
  VaultTest.putIfAbsent,
  VaultTest.getAndPut,
  VaultTest.getAndRemove,
  VaultTest.clear,
  VaultTest.remove,
  VaultTest.removeAll,
  VaultTest.createdEvent,
  VaultTest.updatedEvent,
  VaultTest.removedEvent,
  VaultTest.stats
};

/// Calls [Vault.name] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultName<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final cache = ctx.newVault(store, name: 'test');

  check(ctx, cache.name, isNotNull, '_vaultName_1');
  check(ctx, cache.name, 'test', '_vaultName_2');

  return store;
}

/// Calls [Vault.put] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPut<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
  await vault.put(key, value);

  return store;
}

/// Calls [Vault.put] on a [Vault] backed by the provided [Store] builder
/// and removes the value through [Vault.remove]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutRemove<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  await vault.put('key_1', ctx.generator.nextValue(1));
  var size = await vault.size;
  check(ctx, size, 1, '_vaultPutRemove_1');

  await vault.remove('key_1');
  size = await vault.size;
  check(ctx, size, 0, '_vaultPutRemove_2');

  return store;
}

/// Calls [Vault.size] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultSize<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  await vault.put('key_1', ctx.generator.nextValue(1));
  var size = await vault.size;
  check(ctx, size, 1, '_vaultSize_1');

  await vault.put('key_2', ctx.generator.nextValue(2));
  size = await vault.size;
  check(ctx, size, 2, '_vaultSize_2');

  await vault.put('key_3', ctx.generator.nextValue(3));
  size = await vault.size;
  check(ctx, size, 3, '_vaultSize_3');

  await vault.remove('key_1');
  size = await vault.size;
  check(ctx, size, 2, '_vaultSize_4');

  await vault.remove('key_2');
  size = await vault.size;
  check(ctx, size, 1, '_vaultSize_5');

  await vault.remove('key_3');
  size = await vault.size;
  check(ctx, size, 0, '_vaultSize_6');

  return store;
}

/// Calls [Vault.containsKey] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultContainsKey<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
  await vault.put(key, value);
  final hasKey = await vault.containsKey(key);

  check(ctx, hasKey, isTrue, '_vaultContainsKey_1');

  return store;
}

/// Calls [Vault.keys] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultKeys<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key1 = 'key_1';
  await vault.put(key1, ctx.generator.nextValue(1));

  final key2 = 'key_2';
  await vault.put(key2, ctx.generator.nextValue(2));

  final key3 = 'key_3';
  await vault.put(key3, ctx.generator.nextValue(3));

  final keys = await vault.keys;

  check(ctx, keys, containsAll([key1, key2, key3]), '_vaultKeys_1');

  return store;
}

/// Calls [Vault.put] followed by a [Vault.get] on a [Vault] backed by
/// the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutGet<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key1 = 'key_1';
  var value1 = await vault.get(key1);
  check(ctx, value1, isNull, '_vaultPutGet_1');

  value1 = ctx.generator.nextValue(1);
  await vault.put(key1, value1);
  var value2 = await vault.get(key1);
  check(ctx, value2, value1, '_vaultPutGet_2');

  value1 = null;
  await vault.put(key1, value1);
  value2 = await vault.get(key1);

  check(ctx, value2, value1, '_vaultPutGet_3');

  final key2 = 'key_2';
  final value3 = null;
  await vault.put(key2, value3);
  final value4 = await vault.get(key2);

  check(ctx, value4, value3, '_vaultPutGet_4');

  return store;
}

/// Calls [Vault.put] followed by a operator call on
/// a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutGetOperator<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await vault.put(key, value1);
  final value2 = await vault[key];

  check(ctx, value2, value1, '_vaultPutGetOperator_1');

  return store;
}

/// Calls [Vault.put] followed by a second [Vault.put] on a [Vault] backed by
/// the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutPut<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await vault.put(key, value1);
  var size = await vault.size;
  check(ctx, size, 1, '_vaultPutPut_1');
  var value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultPutPut_2');

  value1 = ctx.generator.nextValue(1);
  await vault.put(key, value1);
  size = await vault.size;
  check(ctx, size, 1, '_vaultPutPut_3');
  value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultPutPut_4');

  return store;
}

/// Calls [Vault.putIfAbsent] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutIfAbsent<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  var added = await vault.putIfAbsent(key, value1);
  check(ctx, added, isTrue, '_vaultPutIfAbsent_1');
  var size = await vault.size;
  check(ctx, size, 1, '_vaultPutIfAbsent_2');
  var value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultPutIfAbsent_3');

  added = await vault.putIfAbsent(key, ctx.generator.nextValue(2));
  check(ctx, added, isFalse, '_vaultPutIfAbsent_4');
  size = await vault.size;
  check(ctx, size, 1, '_vaultPutIfAbsent_5');
  value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultPutIfAbsent_6');

  return store;
}

/// Calls [Vault.getAndPut] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultGetAndPut<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await vault.put(key, value1);
  final value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultGetAndPut_1');

  final value3 = ctx.generator.nextValue(3);
  final value4 = await vault.getAndPut(key, value3);
  check(ctx, value4, value1, '_vaultGetAndPut_2');

  final value5 = await vault.get(key);
  check(ctx, value5, value3, '_vaultGetAndPut_3');

  return store;
}

/// Calls [Vault.getAndRemove] on a [Vault] backed by the provided [Store] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultGetAndRemove<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await vault.put(key, value1);
  final value2 = await vault.get(key);
  check(ctx, value2, value1, '_vaultGetAndRemove_1');

  final value3 = await vault.getAndRemove(key);
  check(ctx, value3, value1, '_vaultGetAndRemove_2');

  final size = await vault.size;
  check(ctx, size, 0, '_vaultGetAndRemove_3');

  return store;
}

/// Calls [Vault.clear] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultClear<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  await vault.put('key_1', ctx.generator.nextValue(1));
  await vault.put('key_2', ctx.generator.nextValue(2));
  await vault.put('key_3', ctx.generator.nextValue(3));
  var size = await vault.size;
  check(ctx, size, 3, '_vaultClear_1');

  await vault.clear();
  size = await vault.size;
  check(ctx, size, 0, '_vaultClear_2');

  return store;
}

/// Calls [Vault.remove] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultRemove<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  await vault.put('key_1', ctx.generator.nextValue(1));
  await vault.put('key_2', ctx.generator.nextValue(2));
  await vault.put('key_3', ctx.generator.nextValue(3));
  var size = await vault.size;
  check(ctx, size, 3, '_vaultRemove_1');

  final key = 'key_2';
  await vault.remove(key);
  size = await vault.size;
  check(ctx, size, 2, '_vaultRemove_2');

  final hasKey = await vault.containsKey(key);
  check(ctx, hasKey, isFalse, '_vaultRemove_3');

  return store;
}

/// Calls [Vault.removeAll] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultRemoveAll<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  await vault.put('key_1', ctx.generator.nextValue(1));
  await vault.put('key_2', ctx.generator.nextValue(2));
  await vault.put('key_3', ctx.generator.nextValue(3));
  var size = await vault.size;
  check(ctx, size, 3, '_vaultRemoveAll_1');

  final keys = {'key_1', 'key_2'};
  await vault.removeAll(keys);
  size = await vault.size;
  check(ctx, size, 1, '_vaultRemoveAll_2');

  final hasKey = await vault.containsKey('key_3');
  check(ctx, hasKey, isTrue, '_vaultRemoveAll_3');

  return store;
}

/// Builds a [Vault] backed by the provided [Store] builder
/// configured with a [VaultEntryCreatedEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultCreatedEvent<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final clock1 = Clock.fixed(now1);
  var clock = clock1;
  VaultEntryCreatedEvent? created;
  final cache = ctx.newVault(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<VaultEntryCreatedEvent>().listen((event) => created = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_vaultCreatedEvent_1');
  check(ctx, created?.source, cache, '_vaultCreatedEvent_2');
  check(ctx, created?.type, VaultEventType.created, '_vaultCreatedEvent_3');
  check(ctx, created?.entry.key, key, '_vaultCreatedEvent_4');
  check(ctx, created?.entry.value, value1, '_vaultCreatedEvent_5');
  check(ctx, created?.entry.creationTime, clock.now(), '_vaultCreatedEvent_6');
  check(ctx, created?.entry.accessTime, clock.now(), '_vaultCreatedEvent_7');
  check(ctx, created?.entry.updateTime, clock.now(), '_vaultCreatedEvent_8');

  return store;
}

/// Builds a [Vault] backed by the provided [Store] builder
/// configured with a [VaultEntryUpdatedEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultUpdatedEvent<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now2 = Clock().minutesFromNow(1);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now2);
  var clock = clock1;
  VaultEntryCreatedEvent? created;
  VaultEntryUpdatedEvent? updated;
  final cache = ctx.newVault(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<VaultEntryCreatedEvent>().listen((event) => created = event)
    ..on<VaultEntryUpdatedEvent>().listen((event) => updated = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_vaultUpdatedEvent_1');
  check(ctx, created?.source, cache, '_vaultUpdatedEvent_2');
  check(ctx, created?.type, VaultEventType.created, '_vaultUpdatedEvent_3');
  check(ctx, created?.entry.key, key, '_vaultUpdatedEvent_4');
  check(ctx, created?.entry.value, value1, '_vaultUpdatedEvent_5');
  check(ctx, created?.entry.creationTime, clock.now(), '_vaultUpdatedEvent_6');
  check(ctx, created?.entry.accessTime, clock.now(), '_vaultUpdatedEvent_7');
  check(ctx, created?.entry.updateTime, clock.now(), '_vaultUpdatedEvent_8');

  clock = clock2;
  final value2 = ctx.generator.nextValue(2);
  await cache.put(key, value2);
  check(ctx, updated, isNotNull, '_vaultUpdatedEvent_9');
  check(ctx, updated?.source, cache, '_vaultUpdatedEvent_10');
  check(ctx, updated?.type, VaultEventType.updated, '_vaultUpdatedEvent_11');
  check(ctx, updated?.oldEntry.key, key, '_vaultUpdatedEvent_12');
  check(ctx, updated?.oldEntry.value, value1, '_vaultUpdatedEvent_13');
  check(ctx, updated?.oldEntry.creationTime, clock1.now(),
      '_vaultUpdatedEvent_14');
  check(
      ctx, updated?.oldEntry.accessTime, clock1.now(), '_vaultUpdatedEvent_15');
  check(
      ctx, updated?.oldEntry.updateTime, clock1.now(), '_vaultUpdatedEvent_16');
  check(ctx, updated?.newEntry.key, key, '_vaultUpdatedEvent_17');
  check(ctx, updated?.newEntry.value, value2, '_vaultUpdatedEvent_18');
  check(ctx, updated?.newEntry.creationTime, clock1.now(),
      '_vaultUpdatedEvent_19');
  check(
      ctx, updated?.newEntry.accessTime, clock1.now(), '_vaultUpdatedEvent_20');
  check(
      ctx, updated?.newEntry.updateTime, clock2.now(), '_vaultUpdatedEvent_21');

  return store;
}

/// Builds a [Vault] backed by the provided [Store] builder
/// configured with a [VaultEntryRemovedEvent]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultRemovedEvent<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final now1 = Clock().now();
  final now3 = Clock().minutesFromNow(3);
  final clock1 = Clock.fixed(now1);
  final clock2 = Clock.fixed(now3);
  var clock = clock1;
  VaultEntryCreatedEvent? created;
  VaultEntryRemovedEvent? removed;
  final cache = ctx.newVault(store,
      eventListenerMode: EventListenerMode.synchronous,
      clock: Clock(() => clock.now()))
    ..on<VaultEntryCreatedEvent>().listen((event) => created = event)
    ..on<VaultEntryRemovedEvent>().listen((event) => removed = event);

  final key = 'key_1';
  final value1 = ctx.generator.nextValue(1);
  await cache.put(key, value1);
  check(ctx, created, isNotNull, '_vaultRemovedEvent_1');
  check(ctx, created?.source, cache, '_vaultRemovedEvent_2');
  check(ctx, created?.type, VaultEventType.created, '_vaultRemovedEvent_3');
  check(ctx, created?.entry.key, key, '_vaultRemovedEvent_4');
  check(ctx, created?.entry.value, value1, '_vaultRemovedEvent_5');
  check(ctx, created?.entry.creationTime, clock.now(), '_vaultRemovedEvent_6');
  check(ctx, created?.entry.accessTime, clock.now(), '_vaultRemovedEvent_7');
  check(ctx, created?.entry.updateTime, clock.now(), '_vaultRemovedEvent_8');

  clock = clock2;
  await cache.remove(key);
  check(ctx, removed, isNotNull, '_vaultRemovedEvent_9');
  check(ctx, removed?.source, cache, '_vaultRemovedEvent_10');
  check(ctx, removed?.type, VaultEventType.removed, '_vaultRemovedEvent_11');
  check(ctx, removed?.entry.key, key, '_vaultRemovedEvent_12');
  check(ctx, removed?.entry.value, value1, '_vaultRemovedEvent_13');
  check(
      ctx, removed?.entry.creationTime, clock1.now(), '_vaultRemovedEvent_14');
  check(ctx, removed?.entry.accessTime, clock1.now(), '_vaultRemovedEvent_15');
  check(ctx, removed?.entry.updateTime, clock1.now(), '_vaultRemovedEvent_16');

  return store;
}

/// Builds a [Vault] backed by the provided [Store] builder
/// configured with stats
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultStats<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  var systemTime = Clock().now();
  final clock = Clock(() {
    systemTime = systemTime.add(Duration(milliseconds: 10));
    return systemTime;
  });
  final vault = ctx.newVault(store, clock: clock, statsEnabled: true);

  // Get a non existing entry
  final key1 = 'key_1';
  var value = await vault.get(key1);
  check(ctx, value, isNull, '_vaultStats_01');
  check(ctx, vault.stats.gets, 1, '_vaultStats_02');
  check(ctx, vault.stats.averageGetTime, 10.0, '_vaultStats_03');

  // Put a value
  final value1 = ctx.generator.nextValue(1);
  await vault.put(key1, value1);
  value = await vault.get(key1);
  check(ctx, value, isNotNull, '_vaultStats_05');
  check(ctx, vault.stats.gets, 2, '_vaultStats_06');
  check(ctx, vault.stats.puts, 1, '_vaultStats_07');
  check(ctx, vault.stats.averagePutTime, 10.0, '_vaultStats_08');

  // Remove a value
  await vault.remove(key1);
  check(ctx, vault.stats.gets, 2, '_vaultStats_09');
  check(ctx, vault.stats.puts, 1, '_vaultStats_10');
  check(ctx, vault.stats.removals, 1, '_vaultStats_11');
  check(ctx, vault.stats.averageRemoveTime, 10.0, '_vaultStats_12');

  return store;
}

/// Returns the list of vault tests to execute
///
/// * [tests]: The set of tests
List<Future<T> Function(VaultTestContext<T>)>
    _getVaultTests<T extends Store<VaultInfo, VaultEntry>>(
        {Set<VaultTest> tests = _vaultTests}) {
  return [
    if (tests.contains(VaultTest.name)) _vaultName,
    if (tests.contains(VaultTest.put)) _vaultPut,
    if (tests.contains(VaultTest.putRemove)) _vaultPutRemove,
    if (tests.contains(VaultTest.size)) _vaultSize,
    if (tests.contains(VaultTest.containsKey)) _vaultContainsKey,
    if (tests.contains(VaultTest.keys)) _vaultKeys,
    if (tests.contains(VaultTest.putGet)) _vaultPutGet,
    if (tests.contains(VaultTest.putGetOperator)) _vaultPutGetOperator,
    if (tests.contains(VaultTest.putPut)) _vaultPutPut,
    if (tests.contains(VaultTest.putIfAbsent)) _vaultPutIfAbsent,
    if (tests.contains(VaultTest.getAndPut)) _vaultGetAndPut,
    if (tests.contains(VaultTest.getAndRemove)) _vaultGetAndRemove,
    if (tests.contains(VaultTest.clear)) _vaultClear,
    if (tests.contains(VaultTest.remove)) _vaultRemove,
    if (tests.contains(VaultTest.removeAll)) _vaultRemoveAll,
    if (tests.contains(VaultTest.createdEvent)) _vaultCreatedEvent,
    if (tests.contains(VaultTest.updatedEvent)) _vaultUpdatedEvent,
    if (tests.contains(VaultTest.removedEvent)) _vaultRemovedEvent,
    if (tests.contains(VaultTest.stats)) _vaultStats
  ];
}

/// Entry point for the vault testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the [Store] creation,
/// the [Vault] creation and by the generation of testing values
/// (with a provided [ValueGenerator] instance). They are encapsulated in provided [VaultTestContext] object
///
/// * [ctx]: the test context
/// * [vaultTests]: The set of tests
Future<void> testVaultWith<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContext<T> ctx,
    {Set<VaultTest> vaultTests = _vaultTests}) async {
  for (var test in _getVaultTests<T>(tests: vaultTests)) {
    await test(ctx).then(ctx.deleteStore);
  }
}

/// Default vault test
///
/// * [newVaultTestContext]: The context builder
/// * [types]: The type/generator map
/// * [vaultTests]: The vault test set
void testVault<T extends Store<VaultInfo, VaultEntry>>(
    VaultTestContextBuilder<T> newVaultTestContext,
    {Map<TypeTest, Function>? types,
    Set<VaultTest> vaultTests = _vaultTests}) {
  for (var entry in (types ?? _typeTests).entries) {
    test('Vault: ${entry.key.name}', () async {
      await testVaultWith<T>(newVaultTestContext(entry.value()),
          vaultTests: vaultTests);
    });
  }
}
