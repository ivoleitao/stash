import 'package:equatable/equatable.dart';

/// Base class with all the stat fields
class Stat with EquatableMixin {
  /// The key
  final String key;

  /// Stat creation time
  final DateTime creationTime;

  /// Stat access time
  DateTime accessTime;

  /// Stat update time
  DateTime updateTime;

  /// Builds a [Stat]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  Stat(this.key, this.creationTime,
      {DateTime? accessTime, DateTime? updateTime})
      : accessTime = accessTime ?? creationTime,
        updateTime = updateTime ?? creationTime;

  @override
  List<Object?> get props => [key, creationTime, accessTime, updateTime];
}
