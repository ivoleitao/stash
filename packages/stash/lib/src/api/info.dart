import 'package:equatable/equatable.dart';

/// Base class with all the info fields
class Info with EquatableMixin {
  /// The key
  final String key;

  /// Info creation time
  final DateTime creationTime;

  /// Info access time
  DateTime accessTime;

  /// Info update time
  DateTime updateTime;

  /// Builds a [Info]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  Info(this.key, this.creationTime,
      {DateTime? accessTime, DateTime? updateTime})
      : accessTime = accessTime ?? creationTime,
        updateTime = updateTime ?? creationTime;

  @override
  List<Object?> get props => [key, creationTime, accessTime, updateTime];
}
