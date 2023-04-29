import 'package:cbl/cbl.dart';
import 'package:stash/stash_api.dart';

import 'cbl_adapter.dart';

/// Couchbase Lite based implementation of a [Store].
abstract class CblStore<I extends Info, E extends Entry<I>>
    extends PersistenceStore<I, E> {
  /// The adapter
  final CblAdapter _adapter;

  /// Creates a Couchbase Lite based implementation of a [Store].
  ///
  /// * [_adapter]: The Couchbase Lite store adapter.
  /// * [codec]: The [StoreCodec] used to convert to/from a
  ///   Map<String, dynamic>` representation to a binary representation.
  CblStore(this._adapter, {super.codec});

  @override
  Future<void> create(String name,
          {dynamic Function(Map<String, dynamic>)? fromEncodable}) =>
      super
          .create(name, fromEncodable: fromEncodable)
          .then((_) => _adapter.create(name));

  @override
  Future<int> size(String name) async => _adapter.database(name)?.count ?? 0;

  @override
  Future<Iterable<String>> keys(String name) async {
    final keys = _adapter.keys(name);
    if (keys == null) {
      return [];
    }
    return keys.toList();
  }

  @override
  Future<Iterable<I>> infos(String name) async {
    final entries = _adapter.entries(name);
    if (entries == null) {
      return [];
    }

    return entries
        .map((entry) =>
            _readInfo(entry.string('id')!, entry.dictionary('properties')!))
        .toList();
  }

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) async {
    final entries = _adapter.entries(name, keys: keys);
    if (entries == null) {
      return [];
    }

    return entries
        .map((entry) => _readInfo(
              entry.string('id')!,
              entry.dictionary('properties')!,
            ))
        .toList();
  }

  @override
  Future<Iterable<E>> values(String name) async {
    final entries = _adapter.entries(name);
    if (entries == null) {
      return [];
    }

    return entries
        .map((entry) => _readEntry(entry.string('id')!,
            entry.dictionary('properties')!, decoder(name)))
        .toList();
  }

  @override
  Future<bool> containsKey(String name, String key) async =>
      (await _adapter.database(name)?.document(key)) != null;

  @override
  Future<I?> getInfo(String name, String key) async {
    final document = await _adapter.database(name)?.document(key);
    if (document == null) {
      return null;
    }
    return _readInfo(document.id, document);
  }

  @override
  Future<void> setInfo(String name, String key, I info) async {
    final database = _adapter.database(name);
    if (database == null) {
      return;
    }

    final document = (await database.document(key))?.toMutable();
    if (document == null) {
      return;
    }

    _writeInfo(document, info);
    await database.saveDocument(document);
  }

  @override
  Future<E?> getEntry(String name, String key) async {
    final document = await _adapter.database(name)?.document(key);
    if (document == null) {
      return null;
    }
    return _readEntry(document.id, document, decoder(name));
  }

  @override
  Future<void> putEntry(String name, String key, E entry) async {
    final database = _adapter.database(name);
    if (database == null) {
      return;
    }

    final document = (await database.document(key))?.toMutable() ??
        MutableDocument.withId(key);

    _writeEntry(document, entry);
    await database.saveDocument(document);
  }

  @override
  Future<void> remove(String name, String key) async {
    // Since we are not replicating the database it is safe to purge the
    // document instead of deleting it. Purging is faster than deleting.
    await _adapter.database(name)?.purgeDocumentById(key);
  }

  @override
  Future<void> clear(String name) async {
    await delete(name);
    await create(name);
  }

  @override
  Future<void> delete(String name) => _adapter.delete(name);

  @override
  Future<void> deleteAll() => _adapter.deleteAll();

  /// Reads the info
  ///
  /// * [id]: The id
  /// * [properties]: The dictory of properties
  I _readInfo(String id, DictionaryInterface properties);

  /// Reads the entry
  ///
  /// * [id]: The id
  /// * [properties]: The dictory of properties
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  E _readEntry(String id, DictionaryInterface properties,
      dynamic Function(Map<String, dynamic>)? fromEncodable);

  /// Loads the value
  ///
  /// * [properties]: The properties
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  dynamic _loadValue(DictionaryInterface properties,
      dynamic Function(Map<String, dynamic>)? fromEncodable) {
    return decodeValue(properties.array('value')!.toPlainList(), fromEncodable,
        processor: ValueProcessor.cast);
  }

  /// Writes the entry
  ///
  /// * [document]: The document
  /// * [entry]: The entry
  void _writeEntry(MutableDocument document, E entry) {
    document.setDate(entry.creationTime, key: 'creationTime');
    _writeInfo(document, entry.info);
    _writeValue(document, entry.value);
  }

  /// Writes the info
  ///
  /// * [document]: The document
  //  * [info]: The info
  void _writeInfo(MutableDocument document, I info) {
    document
      ..setDate(info.accessTime, key: 'accessTime')
      ..setDate(info.updateTime, key: 'updateTime');
  }

  /// Writes the value
  ///
  /// * [properties]: The properties
  //  * [value]: The value
  void _writeValue(MutableDictionaryInterface properties, dynamic value) {
    properties.setValue(encodeValue(value), key: 'value');
  }
}

class CblVaultStore extends CblStore<VaultInfo, VaultEntry>
    implements VaultStore {
  CblVaultStore(super.adapter, {super.codec});

  @override
  VaultInfo _readInfo(String id, DictionaryInterface properties) => VaultInfo(
        id,
        properties.date('creationTime')!,
        accessTime: properties.date('accessTime'),
        updateTime: properties.date('updateTime'),
      );

  @override
  VaultEntry _readEntry(String id, DictionaryInterface properties,
          dynamic Function(Map<String, dynamic>)? fromEncodable) =>
      VaultEntry.loaded(
        id,
        properties.date('creationTime')!,
        _loadValue(properties, fromEncodable),
        accessTime: properties.date('accessTime'),
        updateTime: properties.date('updateTime'),
      );
}

class CblCacheStore extends CblStore<CacheInfo, CacheEntry>
    implements CacheStore {
  CblCacheStore(super.adapter, {super.codec});

  @override
  CacheInfo _readInfo(String id, DictionaryInterface properties) => CacheInfo(
        id,
        properties.date('creationTime')!,
        properties.date('expiryTime')!,
        accessTime: properties.date('accessTime'),
        updateTime: properties.date('updateTime'),
        hitCount: properties.integer('hitCount'),
      );

  @override
  CacheEntry _readEntry(String id, DictionaryInterface properties,
          dynamic Function(Map<String, dynamic>)? fromEncodable) =>
      CacheEntry.loaded(
        id,
        properties.date('creationTime')!,
        properties.date('expiryTime')!,
        _loadValue(properties, fromEncodable),
        accessTime: properties.date('accessTime'),
        updateTime: properties.date('updateTime'),
        hitCount: properties.integer('hitCount'),
      );

  @override
  void _writeInfo(MutableDocument document, CacheInfo info) {
    super._writeInfo(document, info);
    document
      ..setDate(info.expiryTime, key: 'expiryTime')
      ..setInteger(info.hitCount, key: 'hitCount');
  }
}
