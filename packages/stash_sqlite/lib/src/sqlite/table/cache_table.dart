import 'package:drift/drift.dart';

import 'iso8601_converter.dart';

@DataClassName('CacheData')

/// Definition of the table that stores each of the cache entries
class CacheTable extends Table {
  @override
  String get tableName => 'Cache';

  /// Returns a [TextColumn] for the name
  TextColumn get name => text()();

  /// Returns a [TextColumn] for the key
  TextColumn get key => text()();

  /// Returns a [TextColumn] that stores the creation time with a String format through the [Iso8601Converter]
  TextColumn get creationTime => text().map(const Iso8601Converter())();

  /// Returns a [TextColumn] that stores the expiry time with a String format through the [Iso8601Converter]
  TextColumn get expiryTime => text().map(const Iso8601Converter())();

  /// Returns a [TextColumn] that stores the access time with a String format through the [Iso8601Converter]
  TextColumn get accessTime => text().map(const Iso8601Converter())();

  /// Returns a [TextColumn] that stores the update time with a String format through the [Iso8601Converter]
  TextColumn get updateTime => text().map(const Iso8601Converter())();

  /// Returns a [IntColumn] for the hit count
  IntColumn get hitCount => integer()();

  /// Returns a [BlobColumn] to store the value field
  BlobColumn get value => blob()();

  @override
  Set<Column> get primaryKey => {name, key};
}
