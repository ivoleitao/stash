import 'package:stash/stash_api.dart';

/// In-memory [Map] backed implementation of a [Store]
abstract class MemoryStore<I extends Info, E extends Entry<I>>
    implements Store<I, E> {
  /// In-memory [Map] to stores multiple entries.
  /// The value is a [Map] of key/[Entry]
  final Map<String, Map<String, E>> _stores = <String, Map<String, E>>{};

  /// Returns a specific record identified by [name] or a empty [Map] of key/[Entry]
  Future<Map<String, E>> _store(String name) {
    if (_stores.containsKey(name)) {
      return Future.value(_stores[name]);
    }

    final store = <String, E>{};

    _stores[name] = store;

    return Future.value(store);
  }

  @override
  Future<int> size(String name) => _store(name).then((store) => store.length);

  @override
  Future<Iterable<String>> keys(String name) =>
      _store(name).then((store) => store.keys);

  @override
  Future<Iterable<I>> infos(String name) =>
      _store(name).then((store) => store.values.map((value) => value.info));

  @override
  Future<Iterable<E>> values(String name) =>
      _store(name).then((store) => store.values);

  @override
  Future<bool> containsKey(String name, String key) {
    return _store(name).then((store) => store.containsKey(key));
  }

  @override
  Future<I?> getInfo(String name, String key) {
    return _store(name).then((store) => store[key]?.info);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    return _store(name).then((store) => keys.map((key) => store[key]?.info));
  }

  @override
  Future<void> setInfo(String name, String key, I info) {
    final store = _stores[name];

    if (store != null) {
      final entry = store[key];

      if (entry != null) {
        entry.updateInfo(info);
      }
    }
    return Future.value();
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return _store(name).then((store) => store[key]);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    return _store(name).then((store) => store[key] = entry);
  }

  @override
  Future<void> remove(String name, String key) {
    return _store(name).then((store) => store.remove(key));
  }

  @override
  Future<void> clear(String name) {
    return _store(name).then((store) => store.clear());
  }

  @override
  Future<void> delete(String name) {
    if (_stores.containsKey(name)) {
      _stores.remove(name);
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    _stores.clear();

    return Future.value();
  }
}

class MemoryVaultStore extends MemoryStore<VaultInfo, VaultEntry> {}

class MemoryCacheStore extends MemoryStore<CacheInfo, CacheEntry> {}
