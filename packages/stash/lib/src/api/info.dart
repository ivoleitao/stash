import 'package:equatable/equatable.dart';

/// Base class with all the info fields
class Info with EquatableMixin {
  /// The key
  final String key;

  /// Info creation time
  final DateTime creationTime;

  /// The type
  final int type;

  /// Info access time
  DateTime accessTime;

  /// Info update time
  DateTime updateTime;

  /// Builds a [Info]
  ///
  /// * [key]: The key
  /// * [creationTime]: The creation time
  /// * [type]: The type
  /// * [accessTime]: The access time
  /// * [updateTime]: The update time
  Info(this.key, this.creationTime,
      {int? type, DateTime? accessTime, DateTime? updateTime})
      : type = type ?? 0,
        accessTime = accessTime ?? creationTime,
        updateTime = updateTime ?? creationTime;

  @override
  List<Object?> get props => [key, creationTime, type, accessTime, updateTime];
}
