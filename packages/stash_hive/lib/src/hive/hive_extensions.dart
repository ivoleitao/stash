import 'package:stash/src/api/cache_entry.dart';

/// Extensions to a [CacheEntry] to provide support to Hive
extension HiveExtensions on CacheEntry {
  /// Checks if the [value] is one of the base datatypes supported by Hive either returning that value if it is or
  /// invoking toJson to transform it in a supported value
  ///
  /// * [value]: the value to convert
  static dynamic _toJsonValue(dynamic value) {
    if (value == null ||
        value is bool ||
        value is int ||
        value is double ||
        value is String ||
        value is DateTime ||
        value is BigInt ||
        value is List ||
        value is Map) {
      return value;
    }

    return value.toJson();
  }

  /// Creates a [CacheEntry] from json map
  ///
  /// * [json]: the serialized json map stored in Hive
  /// * [fromJson]: optional function to convert the value to the object stored in the cache
  static CacheEntry fromJson(Map<String, dynamic> json,
      {dynamic Function(Map<String, dynamic>)? fromJson}) {
    return CacheEntry(
      json['key'] as String,
      json['value'] == null
          ? null
          : fromJson != null
              ? fromJson((json['value'] as Map).cast<String, dynamic>())
              : json['value'],
      DateTime.parse(json['expiryTime'] as String),
      DateTime.parse(json['creationTime'] as String),
      accessTime: json['accessTime'] == null
          ? null
          : DateTime.parse(json['accessTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      hitCount: json['hitCount'] as int?,
    );
  }

  /// Creates a json map from a [CacheEntry]. The value is either handled as is or converted to a supported data
  /// structure
  Map<String, dynamic> toHiveJson() => <String, dynamic>{
        'key': key,
        'expiryTime': expiryTime.toIso8601String(),
        'creationTime': creationTime.toIso8601String(),
        'accessTime': accessTime.toIso8601String(),
        'updateTime': updateTime.toIso8601String(),
        'hitCount': hitCount,
        'value': _toJsonValue(value),
      };
}
