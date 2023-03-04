import 'package:drift/drift.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/src/sqlite/table/iso8601_converter.dart';
import 'package:stash_sqlite/src/sqlite/table/vault_table.dart';
import 'package:stash_sqlite/src/sqlite/vault_database.dart';

import 'dao_adapter.dart';

part 'vault_dao.g.dart';

@DriftAccessor(tables: [VaultTable])

/// Dao that encapsulates operations over the database
class VaultDao extends DatabaseAccessor<VaultDatabase>
    with _$VaultDaoMixin
    implements DaoAdapter<VaultInfo, VaultEntry> {
  /// Builds a [VaultDao]
  ///
  /// * [db]: The [VaultDatabase]
  VaultDao(super.db);

  /// Counts the number of entries on a named vault
  ///
  /// * [name]: The name of the vault
  ///
  /// Returns the number of entries on the named vault
  @override
  Future<int> count(String name) {
    final countColumn = vaultTable.key.count();
    final query = selectOnly(vaultTable)
      ..addColumns([countColumn])
      ..where(vaultTable.name.equals(name));

    return query
        .map((row) => row.read(countColumn))
        .getSingle()
        .then((value) => value ?? 0);
  }

  /// Returns all the keys on a named vault
  ///
  /// * [name]: The name of the vault
  ///
  /// Returns all the keys on the named vault
  @override
  Future<List<String>> keys(String name) {
    final keyColumn = vaultTable.key;
    final query = selectOnly(vaultTable)
      ..addColumns([keyColumn])
      ..where(vaultTable.name.equals(name));

    return query
        .map((row) => row.read(keyColumn))
        .get()
        .then((keys) => keys.map((key) => key!).toList());
  }

  /// Builds and returns the query that retrieves header information from the vault
  JoinedSelectStatement<$VaultTableTable, VaultData> _infoQuery() {
    return selectOnly(vaultTable)
      ..addColumns([
        vaultTable.key,
        vaultTable.creationTime,
        vaultTable.accessTime,
        vaultTable.updateTime
      ]);
  }

  /// Converts from a [TypedResult] row to a [VaultInfo]
  ///
  /// * [row]: The [TypedResult] row
  ///
  /// Returns the [VaultInfo] after conversion
  VaultInfo _infoMapper(TypedResult row) {
    final converter = const Iso8601Converter();

    final key = row.read(vaultTable.key);
    var creationTime = converter.mapToDart(row.read(vaultTable.creationTime));
    var accessTime = converter.mapToDart(row.read(vaultTable.accessTime));
    var updateTime = converter.mapToDart(row.read(vaultTable.updateTime));

    return VaultInfo(key!, creationTime!,
        accessTime: accessTime, updateTime: updateTime);
  }

  /// Returns the list of all vault headers on a named vault
  ///
  /// * [name]: The name of the vault
  ///
  /// Returns a [Iterable] over all [VaultInfo]s
  @override
  Future<Iterable<VaultInfo>> infos(String name) {
    var query = _infoQuery()..where(vaultTable.name.equals(name));

    return query.map(_infoMapper).get();
  }

  /// Converts a [VaultData] to a [VaultEntry]
  ///
  /// * [data]: The [VaultData]
  /// * [valueDecoder]: The function used to convert a list of bytes to the vault value
  ///
  /// Returns the [VaultEntry] after conversion
  VaultEntry? _toVaultEntry(
      VaultData? data, dynamic Function(Uint8List) valueDecoder) {
    return data != null
        ? VaultEntry.loaded(
            data.key, data.creationTime, valueDecoder(data.value),
            accessTime: data.accessTime, updateTime: data.updateTime)
        : null;
  }

  /// Returns the list of all vault entries on a named vault
  ///
  /// * [name]: The name of the vault
  ///
  /// Returns a [Iterable] over all [VaultEntry]s
  @override
  Future<Iterable<VaultEntry>> entries(
      String name, dynamic Function(Uint8List) valueDecoder) {
    return (select(vaultTable)..where((entry) => entry.name.equals(name)))
        .get()
        .then((entries) =>
            entries.map((entry) => _toVaultEntry(entry, valueDecoder)!));
  }

  /// Checks if a key exists on a named vault
  ///
  /// * [name]: The name of the vault
  /// * [key]: The key to check on the named vault
  ///
  /// Returns true if the named vault contains the provided key, false otherwise
  @override
  Future<bool> containsKey(String name, String key) {
    return (select(vaultTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .getSingleOrNull()
        .then((value) => value != null);
  }

  /// Returns a vault header for a key on named vault
  ///
  /// * [name]: The name of the vault
  /// * [key]: The key on the vault
  ///
  /// Returns the named vault key [VaultInfo]
  @override
  Future<VaultInfo?> getInfo(String name, String key) {
    var query = _infoQuery()
      ..where(vaultTable.name.equals(name) & vaultTable.key.equals(key));

    return query.map(_infoMapper).getSingleOrNull();
  }

  /// Returns the list of all vault headers on a named vault, filtered by the provided keys
  ///
  /// * [name]: The name of the vault
  /// * [keys]: The list of keys
  ///
  /// Returns a [Iterable] over all [VaultInfo]s retrieved
  @override
  Future<Iterable<VaultInfo>> getInfos(String name, Iterable<String> keys) {
    var query = _infoQuery()
      ..where(vaultTable.name.equals(name) & vaultTable.key.isIn(keys));

    return query.map(_infoMapper).get();
  }

  /// Updates the header of a named vault
  ///
  /// * [name]: The name of the vault
  /// * [stat]: The [VaultInfo]
  ///
  /// Returns the number of updated enties
  @override
  Future<int> updateInfo(String name, VaultInfo info) {
    return (update(vaultTable)
          ..where(
              (entry) => entry.name.equals(name) & entry.key.equals(info.key)))
        .write(VaultTableCompanion(
            creationTime: Value(info.creationTime),
            accessTime: Value(info.accessTime),
            updateTime: Value(info.updateTime)));
  }

  /// Returns a vault entry for a key on named vault
  ///
  /// * [name]: The name of the vault
  /// * [key]: The key on the vault
  /// * [valueDecoder]: The function used to convert a list of bytes to the vault value
  ///
  /// Returns the named vault key [VaultEntry]
  @override
  Future<VaultEntry?> getEntry(
      String name, String key, dynamic Function(Uint8List) valueDecoder) {
    return (select(vaultTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .getSingleOrNull()
        .then((entry) => _toVaultEntry(entry, valueDecoder));
  }

  /// Creates a [VaultData] for a named vault entry
  ///
  /// * [name]: The name of the vault
  /// * [entry]: The vault entry
  /// * [valueEncoder]: The function used to serialize a object to a list of bytes
  ///
  /// Return a [VaultData] for storage
  VaultData _toVaultData(
      String name, VaultEntry entry, Uint8List Function(dynamic) valueEncoder) {
    return VaultData(
        name: name,
        key: entry.key,
        creationTime: entry.creationTime,
        accessTime: entry.accessTime,
        updateTime: entry.updateTime,
        value: valueEncoder(entry.value));
  }

  /// Adds a [VaultEntry] to the named vault
  ///
  /// * [name]: The name of the vault
  /// * [entry]: The vault entry
  /// * [valueEncoder]: The function used to serialize a object to a list of bytes
  @override
  Future<void> putEntry(
      String name, VaultEntry entry, Uint8List Function(dynamic) valueEncoder) {
    return into(vaultTable).insert(_toVaultData(name, entry, valueEncoder),
        mode: InsertMode.insertOrReplace);
  }

  /// Removes a entry from a named vault
  ///
  /// * [name]: The name of thevault
  /// * [key]: The vault key
  ///
  /// Returns the number of records updated
  @override
  Future<int> remove(String name, String key) {
    return (delete(vaultTable)
          ..where((entry) => entry.name.equals(name) & entry.key.equals(key)))
        .go();
  }

  /// Clears a named vault
  ///
  /// * [name]: The name of the vault
  ///
  /// Return the number of records updated
  @override
  Future<int> clear(String name) {
    return (delete(vaultTable)..where((entry) => entry.name.equals(name))).go();
  }

  /// Deletes all vaults
  ///
  /// Return the number of records updated
  @override
  Future<int> clearAll() {
    return delete(vaultTable).go();
  }
}
