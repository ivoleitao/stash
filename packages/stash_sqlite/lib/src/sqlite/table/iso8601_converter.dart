import 'package:drift/drift.dart';

/// Provides a [TypeConverter] for Drift that stores a [Datetime] in
/// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format
class Iso8601Converter extends TypeConverter<DateTime, String> {
  /// Builds a new [Iso8601Converter]
  const Iso8601Converter();

  @override
  DateTime fromSql(String fromDb) {
    return DateTime.parse(fromDb);
  }

  @override
  String toSql(DateTime value) {
    return value.toIso8601String();
  }

  DateTime? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }

    return fromSql(fromDb);
  }

  String? mapToSql(DateTime? value) {
    if (value == null) {
      return null;
    }

    return toSql(value);
  }
}
