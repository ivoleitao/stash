import 'dart:typed_data';

import 'package:cbl/cbl.dart';
import 'package:stash/stash_api.dart';
import 'package:stash/stash_msgpack.dart';

import 'cbl_adapter.dart';

/// Couchbase Lite based implementation of a [Store].
abstract class CblStore<I extends Info, E extends Entry<I>>
    extends Store<I, E> {
  /// Creates a Couchbase Lite based implementation of a [Store].
  ///
  /// * [_adapter]: The Couchbase Lite store adapter.
  /// * [codec]: The [StoreCodec] used to convert to/from a
  ///   Map<String, dynamic>` representation to a binary representation.
  /// * [fromEncodable]: A custom function the converts to the object from a
  ///   `Map<String, dynamic>` representation.
  CblStore(
    this._adapter, {
    StoreCodec? codec,
    dynamic Function(Map<String, dynamic>)? fromEncodable,
  })  : _codec = codec ?? const MsgpackCodec(),
        _fromEncodable = fromEncodable;

  final CblAdapter _adapter;

  final StoreCodec _codec;

  final dynamic Function(Map<String, dynamic>)? _fromEncodable;

  @override
  Future<void> create(String name) => _adapter.create(name);

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
  Future<Iterable<I>> infos(String name) async =>
      (await values(name)).map((entry) => entry.info);

  @override
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys) async {
    final entries = _adapter.entries(name, keys: keys);
    if (entries == null) {
      return [];
    }

    return entries
        .map((entry) => _loadEntry(
              entry.string('id')!,
              entry.dictionary('properties')!,
            ).info)
        .toList();
  }

  @override
  Future<Iterable<E>> values(String name) async {
    final entries = _adapter.entries(name);
    if (entries == null) {
      return [];
    }

    return entries
        .map((entry) => _loadEntry(
              entry.string('id')!,
              entry.dictionary('properties')!,
            ))
        .toList();
  }

  @override
  Future<bool> containsKey(String name, String key) async =>
      (await _adapter.database(name)?.document(key)) != null;

  @override
  Future<I?> getInfo(String name, String key) async =>
      (await getEntry(name, key))?.info;

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
    return _loadEntry(document.id, document);
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

  E _loadEntry(String id, DictionaryInterface properties);

  dynamic _loadValue(DictionaryInterface properties) {
    final valueBytes = Uint8List.fromList(
      properties.array('value')!.toPlainList().cast<int>(),
    );
    final reader = _codec.decoder(valueBytes, fromEncodable: _fromEncodable);
    return reader.read();
  }

  void _writeEntry(MutableDocument document, E entry) {
    document.setDate(entry.creationTime, key: 'creationTime');
    _writeInfo(document, entry.info);
    _writeValue(document, entry.value);
  }

  void _writeInfo(MutableDocument document, I info) {
    document
      ..setDate(info.accessTime, key: 'accessTime')
      ..setDate(info.updateTime, key: 'updateTime');
  }

  void _writeValue(MutableDictionaryInterface properties, dynamic value) {
    final writer = _codec.encoder();
    writer.write(value);
    properties.setValue(writer.takeBytes(), key: 'value');
  }
}

class CblVaultStore extends CblStore<VaultInfo, VaultEntry> {
  CblVaultStore(CblAdapter adapter, {super.codec, super.fromEncodable})
      : super(adapter);

  @override
  VaultEntry _loadEntry(String id, DictionaryInterface properties) =>
      VaultEntry.loadEntry(
        id,
        properties.date('creationTime')!,
        _loadValue(properties),
        accessTime: properties.date('accessTime'),
        updateTime: properties.date('updateTime'),
      );
}

class CblCacheStore extends CblStore<CacheInfo, CacheEntry> {
  CblCacheStore(CblAdapter adapter, {super.codec, super.fromEncodable})
      : super(adapter);

  @override
  CacheEntry _loadEntry(String id, DictionaryInterface properties) =>
      CacheEntry.loadEntry(
        id,
        properties.date('creationTime')!,
        properties.date('expiryTime')!,
        _loadValue(properties),
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