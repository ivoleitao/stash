import 'package:equatable/equatable.dart';

/// The cached response
class CacheValue extends Equatable {
  /// Http status code.
  final int? statusCode;

  /// Response headers.
  final List<int>? headers;

  /// The date after which the value needs to refreshed
  final DateTime? staleDate;

  /// Response bytes
  final List<int>? data;

  /// Builds a [CacheValue]
  ///
  /// * [statusCode]: The HTTP status code
  /// * [headers]: The response headers
  /// * [staleDate]: The date after which the value needs to refreshed
  /// * [data]: The response bytes
  CacheValue({this.statusCode, this.headers, this.staleDate, this.data});

  /// If the stale time was exceeded
  ///
  /// * [now]: An optional datetime with the current date
  bool staleDateExceeded([DateTime? now]) {
    return staleDate != null && staleDate!.isBefore(now ?? DateTime.now());
  }

  /// The [List] of `props` (properties) which will be used to determine whether
  /// two [Equatables] are equal.
  @override
  List<Object?> get props => [statusCode, headers, staleDate, data];

  /// Creates a [CacheValue] from json map
  ///
  /// * [json]: The json map
  factory CacheValue.fromJson(Map<dynamic, dynamic> json) {
    final jsonStaleDate = json['staleDate'] as String?;

    return CacheValue(
      statusCode: json['statusCode'] as int?,
      headers: (json['headers'] as List?)?.map((e) => e as int).toList(),
      staleDate: jsonStaleDate != null ? DateTime.parse(jsonStaleDate) : null,
      data: (json['data'] as List?)?.map((e) => e as int).toList(),
    );
  }

  /// Creates a json map from a [CacheValue]
  Map<String, dynamic> toJson() => <String, dynamic>{
        'statusCode': statusCode,
        'headers': headers,
        'staleDate': staleDate?.toIso8601String(),
        'data': data
      };
}
