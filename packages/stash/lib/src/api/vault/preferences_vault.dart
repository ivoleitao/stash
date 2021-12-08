import 'package:clock/clock.dart';
import 'package:stash/src/api/event.dart';
import 'package:stash/src/api/store.dart';
import 'package:stash/src/api/vault/generic_vault.dart';
import 'package:stash/src/api/vault/preferences.dart';
import 'package:stash/src/api/vault/vault_entry.dart';
import 'package:stash/src/api/vault/vault_info.dart';
import 'package:stash/src/api/vault/vault_manager.dart';
import 'package:stash/src/api/vault/vault_stats.dart';

/// Default implementation of the [Preferences] interface
class PreferencesVault extends GenericVault implements Preferences {
  /// Builds a [PreferencesVault] out of a mandatory [Store] and a set of
  /// optional configurations
  ///
  /// * [storage]: The [Store]
  /// * [manager]: An optional [VaultManager]
  /// * [name]: The name of the vault
  /// * [clock]: The source of time to be used on this, defaults to the system clock if not provided
  /// * [statsEnabled]: If statistics should be collected, defaults to false
  /// * [stats]: The statistics instance
  ///
  /// Returns a [PreferencesVault]
  PreferencesVault(Store<VaultInfo, VaultEntry> storage,
      {VaultManager? manager,
      String? name,
      Clock? clock,
      EventListenerMode? eventListenerMode,
      bool? statsEnabled,
      VaultStats? stats})
      : super(storage,
            manager: manager,
            name: name,
            clock: clock,
            eventListenerMode: eventListenerMode,
            statsEnabled: statsEnabled,
            stats: stats);

  /// Gets a base preference value and casts it to the provided type
  ///
  /// [key]: the key
  /// [def]: the default value
  ///
  /// Returns the preference value
  Future<T?> _getAs<T>(String key, {T? def}) {
    return get(key).then((value) => (value as T?) ?? def);
  }

  /// Gets a preference list and casts it to the provided type
  ///
  /// [key]: the key
  /// [def]: the default value
  ///
  /// Returns the preference value
  Future<List<T>?> _getListOf<T>(String key, {List<T>? def}) {
    return get(key).then((value) => (value as List?)?.cast<T>() ?? def);
  }

  @override
  Future<bool?> getBool(String key, {bool? def}) {
    return _getAs<bool>(key, def: def);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return put(key, value);
  }

  @override
  Future<int?> getInt(String key, {int? def}) {
    return _getAs<int>(key, def: def);
  }

  @override
  Future<void> setInt(String key, int value) {
    return put(key, value);
  }

  @override
  Future<double?> getDouble(String key, {double? def}) {
    return _getAs<double>(key, def: def);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return put(key, value);
  }

  @override
  Future<String?> getString(String key, {String? def}) {
    return _getAs<String>(key, def: def);
  }

  @override
  Future<void> setString(String key, String value) {
    return put(key, value);
  }

  @override
  Future<List<bool>?> getBoolList(String key, {List<bool>? def}) {
    return _getListOf<bool>(key, def: def);
  }

  @override
  Future<void> setBoolList(String key, List<bool> value) {
    return put(key, value);
  }

  @override
  Future<List<int>?> getIntList(String key, {List<int>? def}) {
    return _getListOf<int>(key, def: def);
  }

  @override
  Future<void> setIntList(String key, List<int> value) {
    return put(key, value);
  }

  @override
  Future<List<double>?> getDoubleList(String key, {List<double>? def}) {
    return _getListOf<double>(key, def: def);
  }

  @override
  Future<void> setDoubleList(String key, List<double> value) {
    return put(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key, {List<String>? def}) {
    return _getListOf<String>(key, def: def);
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    return put(key, value);
  }
}
