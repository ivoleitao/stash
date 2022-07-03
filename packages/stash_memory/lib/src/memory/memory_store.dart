import 'package:stash/stash_api.dart';

/// In-memory [Map] backed implementation of a [Store]
abstract class MemoryStore<I extends Info, E extends Entry<I>>
    implements Store<I, E> {
  /// In-memory [Map] to stores multiple entries.
  /// The value is a [Map] of key/[Entry]
  final Map<String, Map<String, E>> _slots = <String, Map<String, E>>{};

  @override
  Future<void> create(String name,
      {dynamic Function(Map<String, dynamic>)? fromEncodable}) {
    if (!_slots.containsKey(name)) {
      _slots[name] = <String, E>{};
    }

    return Future.value();
  }

  /// Returns a specific slot identified by [name]
  ///
  /// * [name]: The slot name
  Map<String, E>? _slot(String name) {
    return _slots[name];
  }

  @override
  Future<int> size(String name) => Future.value(_slot(name)?.length ?? 0);

  @override
  Future<Iterable<String>> keys(String name) =>
      Future.value(_slot(name)?.keys ?? const <String>[]);

  @override
  Future<Iterable<I>> infos(String name) =>
      Future.value((_slot(name)?.values ?? <E>[]).map((value) => value.info));

  @override
  Future<Iterable<E>> values(String name) =>
      Future.value(_slot(name)?.values ?? <E>[]);

  @override
  Future<bool> containsKey(String name, String key) {
    return Future.value(_slot(name)?.containsKey(key) ?? false);
  }

  @override
  Future<I?> getInfo(String name, String key) {
    return Future.value(_slot(name)?[key]?.info);
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) {
    final slot = _slot(name);

    return Future.value(keys.map((key) => slot?[key]?.info));
  }

  @override
  Future<void> setInfo(String name, String key, I info) {
    final slot = _slot(name);

    if (slot != null) {
      final entry = slot[key];

      if (entry != null) {
        entry.updateInfo(info);
      }
    }

    return Future.value();
  }

  @override
  Future<E?> getEntry(String name, String key) {
    return Future.value(_slot(name)?[key]);
  }

  @override
  Future<void> putEntry(String name, String key, E entry) {
    final slot = _slot(name);

    if (slot != null) {
      slot[key] = entry;
    }

    return Future.value();
  }

  @override
  Future<void> remove(String name, String key) {
    final slot = _slot(name);

    if (slot != null) {
      slot.remove(key);
    }

    return Future.value();
  }

  @override
  Future<void> clear(String name) {
    final slot = _slot(name);

    if (slot != null) {
      slot.clear();
    }

    return Future.value();
  }

  @override
  Future<void> delete(String name) {
    if (_slots.containsKey(name)) {
      _slots.remove(name);
    }

    return Future.value();
  }

  @override
  Future<void> deleteAll() {
    _slots.clear();

    return Future.value();
  }
}

class MemoryVaultStore extends MemoryStore<VaultInfo, VaultEntry> {}

class MemoryCacheStore extends MemoryStore<CacheInfo, CacheEntry> {}
