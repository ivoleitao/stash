import 'package:drift/drift.dart';

/// Provides a [TypeConverter] for Drift that stores a [Datetime] in
/// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format
class Iso8601Converter extends TypeConverter<DateTime, String> {
  /// Builds a new [Iso8601Converter]
  const Iso8601Converter();

  @override
  DateTime? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }

    return DateTime.parse(fromDb);
  }

  @override
  String? mapToSql(DateTime? value) {
    if (value == null) {
      return null;
    }

    return value.toIso8601String();
  }
}
