import 'package:sembast/sembast.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sembast/src/sembast/sembast_extensions.dart';

import 'sembast_adapter.dart';

/// Sembast based implemention of a [CacheStore]
class SembastStore extends CacheStore {
  /// The adapter
  final SembastAdapter _adapter;

  /// The function that converts between the Map representation to the
  /// object stored in the cache
  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  /// Builds a [SembastStore].
  ///
  /// * [_adapter]: The sembast store adapter
  /// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
  SembastStore(this._adapter,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : _fromEncodable = fromEncodable;

  @override
  Future<int> size(String name) => _adapter.count(name);

  @override
  Future<Iterable<String>> keys(String name) => _adapter.keys(name);

  /// Retrieves a [CacheEntry] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [CacheEntry]
  CacheEntry? _getEntryFromValue(Map<String, dynamic>? value) {
    return value != null
        ? SembastExtensions.fromJson(value, fromJson: _fromEncodable)
        : null;
  }

  /// Retrieves a [CacheStat] from a json map
  ///
  /// * [value]: The json map
  ///
  ///  Returns the corresponding [CacheStat]
  CacheStat? _getStatFromValue(Map<String, dynamic> value) {
    return _getEntryFromValue(value)?.stat;
  }

  /// Calls the [CacheDao] and retries a [CacheEntry] by key
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  ///  Returns the corresponding [CacheEntry]
  Future<CacheEntry?> _getEntryFromStore(String name, String key) =>
      _adapter.getByKey(name, key).then(_getEntryFromValue);

  /// Returns the [CacheEntry] for the named cache value specified [key].
  ///
  /// * [name]: The cache name
  /// * [key]: The cache key
  ///
  /// Returns a [CacheEntry]
  Future<CacheEntry?> _getEntry(String name, String key) {
    return _getEntryFromStore(name, key);
  }

  /// Gets the list of all the records by cache name
  ///
  /// * [name]: The name of the cache
  ///
  ///  Returns the list of [RecordSnapshot]'s by cache name
  Future<List<RecordSnapshot<String, Map<String, dynamic>>>> _getRecords(
      String name) {
    return _adapter.find(name);
  }

  @override
  Future<Iterable<CacheStat>> stats(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getStatFromValue(record.value))
          .map((stat) => stat!)
          .toList());

  @override
  Future<Iterable<CacheEntry>> values(String name) =>
      _getRecords(name).then((records) => records
          .map((record) => _getEntryFromValue(record.value))
          .map((entry) => entry!)
          .toList());

  @override
  Future<bool> containsKey(String name, String key) =>
      _adapter.exists(name, key);

  @override
  Future<CacheStat?> getStat(String name, String key) {
    return _getEntry(name, key).then((entry) => entry?.stat);
  }

  @override
  Future<Iterable<CacheStat?>> getStats(String name, Iterable<String> keys) {
    return _adapter.getByKeys(name, keys).then((records) =>
        records.map((record) => _getEntryFromValue(record)?.stat).toList());
  }

  @override
  Future<void> setStat(String name, String key, CacheStat stat) {
    return _getEntryFromStore(name, key).then((entry) {
      entry!.updateStat(stat);
      _adapter.put(name, key, entry.toSembastJson());
    });
  }

  @override
  Future<CacheEntry?> getEntry(String name, String key) {
    return _getEntry(name, key);
  }

  @override
  Future<void> putEntry(String name, String key, CacheEntry entry) {
    return _adapter.put(name, key, entry.toSembastJson());
  }

  @override
  Future<void> remove(String name, String key) {
    return _adapter.remove(name, key);
  }

  @override
  Future<void> clear(String name) {
    return _adapter.clear(name);
  }

  @override
  Future<void> delete(String name) {
    return _adapter.delete(name);
  }

  @override
  Future<void> deleteAll() {
    return _adapter.deleteAll();
  }
}
