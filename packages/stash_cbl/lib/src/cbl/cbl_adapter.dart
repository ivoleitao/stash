import 'package:cbl/cbl.dart';

const _keysQuery = '''
SELECT Meta().id
FROM _
''';

const _allEntriesQuery = '''
SELECT Meta().id, * AS properties
FROM _
''';

const _filteredEntriesQuery = r'''
SELECT Meta().id, * AS properties
FROM _
WHERE ARRAY_CONTAINS($keys, Meta().id)
''';

/// The [CblAdapter] provides a bridge between the store and the
/// Couchbase Lite backend.
class CblAdapter {
  CblAdapter._(
    this.path,
    this.async,
    this._encryptionKey,
  );

  /// Builds a [CblAdapter].
  ///
  /// * [path]: The base storage location for this store.
  /// * [async]: Whether to execute database operations asynchronously
  ///   on a background isolate, or synchronously on the main isolate.
  /// * [encryptionKey]: The encryption key to use for encrypting databases.
  static Future<CblAdapter> build(
    String path, {
    bool async = true,
    EncryptionKey? encryptionKey,
  }) async =>
      CblAdapter._(path, async, encryptionKey);

  /// The base location of the Couchbase Lite storage.
  final String path;

  /// Whether to execute database operations asynchronously
  /// on a background isolate, or synchronously on the main isolate.
  final bool async;

  final EncryptionKey? _encryptionKey;

  final Map<String, Database> _databases = {};
  final Map<String, Query> _keysQueries = {};
  final Map<String, Query> _allEntriesQueries = {};
  final Map<String, Query> _filteredEntriesQueries = {};

  Future<void> create(String name) async {
    if (_databases.containsKey(name)) {
      return;
    }

    final configuration = DatabaseConfiguration(
      directory: path,
      encryptionKey: _encryptionKey,
    );

    final database = _databases[name] = async
        ? await Database.openAsync(name, configuration)
        : Database.openSync(name, configuration);

    _keysQueries[name] = await Query.fromN1ql(database, _keysQuery);
    _allEntriesQueries[name] = await Query.fromN1ql(database, _allEntriesQuery);
    _filteredEntriesQueries[name] =
        await Query.fromN1ql(database, _filteredEntriesQuery);
  }

  Database? database(String name) => _databases[name];

  Stream<String>? keys(String name) {
    final query = _keysQueries[name];
    if (query == null) {
      return null;
    }

    return Future.sync(query.execute)
        .asStream()
        .asyncExpand((resultSet) => resultSet.asStream())
        .map((result) => result.string(0)!);
  }

  Stream<Result>? entries(String name, {Iterable<String>? keys}) {
    final query =
        keys != null ? _filteredEntriesQueries[name] : _allEntriesQueries[name];
    if (query == null) {
      return null;
    }

    return Future.sync(() async {
      if (keys != null) {
        await query.setParameters(Parameters({'keys': keys}));
      }
      return query.execute();
    }).asStream().asyncExpand((resultSet) => resultSet.asStream());
  }

  Future<void> delete(String name) async {
    final partition = _databases[name];
    if (partition != null) {
      await partition.delete();
      _databases.remove(name);
    }
  }

  Future<void> deleteAll() => Future.wait(_databases.keys.map(delete));
}
