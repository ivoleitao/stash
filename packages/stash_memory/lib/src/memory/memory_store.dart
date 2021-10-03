import 'package:stash/stash_api.dart';

/// In-memory [Map] backed implementation of a [Store]
abstract class MemoryStore<S extends Stat, E extends Entry<S>>
    implements Store<S, E> {
  /// In-memory [Map] to stores multiple entries.
  /// The value is a [Map] of key/[Entry]
  final Map<String, Map<String, E>> _store = <String, Map<String, E>>{};

  /// Returns a specific record identified by [name] or a empty [Map] of key/[Entry]
  Map<String, E> _memoryStore(String name) => _store[name] ?? <String, E>{};

  @override
  Future<int> size(String name) => Future.value(_memoryStore(name).length);

  @override
  Future<Iterable<String>> keys(String name) =>
      Future.value(_memoryStore(name).keys);

  @override
  Future<Iterable<S>> stats(String name) =>
      Future.value(_memoryStore(name).values.map((value) => value.stat));

  @override
  Future<Iterable<E>> values(String name) =>
      Future.value(_memoryStore(name).values);

  @override
  Future<bool> containsKey(String name, String key) {
    return Future.value(_memoryStore(name).containsKey(key));
  }

  @override
  Future<S?> getStat(String name, String key) {
    return Future.value(_memoryStore(name)[key]?.stat);
  }

  @override
  Future<Iterable<S?>> getStats(String name, Iterable<String> keys) {
    return Future.value(keys.map((key) => _memoryStore(name)[key]?.stat));
  }

  @override
  Future<void> setStat(String name, String key, S stat) {
    _store[name]![key]!.updateStat(stat);
    return Future.value();
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return Future.value(_memoryStore(name)[key]);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    if (!_store.containsKey(name)) {
      _store[name] = {};
    }

    _memoryStore(name)[key] = entry;

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    _memoryStore(name).remove(key);
    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    _memoryStore(name).clear();
    return Future.value();
  }

  @override
  Future<void> delete(String name) {
    _store.remove(name);
    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    _store.clear();
    return Future.value();
  }
}

class MemoryVaultStore extends MemoryStore<VaultStat, VaultEntry> {}

class MemoryCacheStore extends MemoryStore<CacheStat, CacheEntry> {}
