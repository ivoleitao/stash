import 'package:enum_to_string/enum_to_string.dart';
import 'package:matcher/matcher.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';

import 'harness.dart';

/// The default type tests perfomed over a vault
final _typeTests = Map.unmodifiable(typeTests);

/// The supported vault tests
enum VaultTest {
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
  clear
}

/// The set of vault tests
const _vaultTests = {
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
  VaultTest.clear
};

/// Calls [Vault.put] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPut<T extends Store<VaultStat, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key = 'key_1';
  final value = ctx.generator.nextValue(1);
  await vault.put(key, value);

  return store;
}

/// Calls [Vault.put] on a [Vault] backed by the provided [VaultStore] builder
/// and removes the value through [Vault.remove]
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutRemove<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.size] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultSize<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.containsKey] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultContainsKey<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.keys] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultKeys<T extends Store<VaultStat, VaultEntry>>(
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
Future<T> _vaultPutGet<T extends Store<VaultStat, VaultEntry>>(
    VaultTestContext<T> ctx) async {
  final store = await ctx.newStore();
  final vault = ctx.newVault(store);

  final key1 = 'key_1';
  var value1 = ctx.generator.nextValue(1);
  await vault.put(key1, value1);
  var value2 = await vault.get(key1);

  check(ctx, value2, value1, '_vaultPutGet_1');

  value1 = null;
  await vault.put(key1, value1);
  value2 = await vault.get(key1);

  check(ctx, value2, value1, '_vaultPutGet_2');

  final key2 = 'key_2';
  final value3 = null;
  await vault.put(key2, value3);
  final value4 = await vault.get(key2);

  check(ctx, value4, value3, '_vaultPutGet_3');

  return store;
}

/// Calls [Vault.put] followed by a operator call on
/// a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutGetOperator<T extends Store<VaultStat, VaultEntry>>(
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
Future<T> _vaultPutPut<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.putIfAbsent] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultPutIfAbsent<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.getAndPut] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultGetAndPut<T extends Store<VaultStat, VaultEntry>>(
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

/// Calls [Vault.getAndRemove] on a [Vault] backed by the provided [VaultStore] builder
///
/// * [ctx]: The test context
///
/// Returns the created store
Future<T> _vaultGetAndRemove<T extends Store<VaultStat, VaultEntry>>(
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
Future<T> _vaultClear<T extends Store<VaultStat, VaultEntry>>(
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

/// Returns the list of tests to execute
///
/// * [tests]: The set of tests
List<Future<T> Function(VaultTestContext<T>)>
    _getVaultTests<T extends Store<VaultStat, VaultEntry>>(
        {Set<VaultTest> tests = _vaultTests}) {
  return [
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
    if (tests.contains(VaultTest.clear)) _vaultClear
  ];
}

/// Entry point for the vault testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the [Store] creation,
/// the [Vault] creation and by the generation of testing values
/// (with a provided [ValueGenerator] instance). They are encapsulated in provided [VaultTestContext] object
///
/// * [ctx]: the test context
/// * [tests]: The set of tests
Future<void> testVaultWith<T extends Store<VaultStat, VaultEntry>>(
    VaultTestContext<T> ctx,
    {Set<VaultTest> tests = _vaultTests}) async {
  for (var test in _getVaultTests<T>(tests: tests)) {
    await test(ctx).then(ctx.deleteStore);
  }
}

/// Default vault test
///
/// * [newVaultTestContext]: The context builder
/// * [types]: The type/generator map
/// * [tests]: The test set
void testVault<T extends Store<VaultStat, VaultEntry>>(
    VaultTestContextBuilder<T> newVaultTestContext,
    {Map<TypeTest, Function>? types,
    Set<VaultTest> tests = _vaultTests}) {
  for (var entry in (types ?? _typeTests).entries) {
    test('Vault: ${EnumToString.convertToString(entry.key)}', () async {
      await testVaultWith<T>(newVaultTestContext(entry.value()), tests: tests);
    });
  }
}
