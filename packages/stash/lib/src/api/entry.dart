import 'package:equatable/equatable.dart';
import 'package:stash/src/api/stat.dart';

abstract class Entry<T extends Stat> with EquatableMixin {
  /// The stat
  final T stat;

  /// The value
  final dynamic value;

  /// Tracks any changes to the [Entry] after obtaining it from the store
  final bool? _valueChanged;

  /// The key getter
  String get key => stat.key;

  /// The creation time getter
  DateTime get creationTime => stat.creationTime;

  /// The access time getter
  DateTime get accessTime => stat.accessTime;

  /// The access time setter
  ///
  /// * [accessTime]: The access time
  set accessTime(DateTime accessTime) {
    stat.accessTime = accessTime;
  }

  /// The update time getter
  DateTime get updateTime => stat.updateTime;

  /// The update time setter
  ///
  /// * [updateTime]: The update time
  set updateTime(DateTime updateTime) {
    stat.updateTime = updateTime;
  }

  /// Returns true if the value was changed after retrieval from the store or if it was newly created
  bool get valueChanged => _valueChanged ?? true;

  /// Builds a [Entry]
  ///
  /// * [stat]: The entry stat
  /// * [value]: The entry value
  /// * [valueChanged]: If this value was changed
  Entry(this.stat, this.value, this._valueChanged);

  /// Updates a [Entry] stat
  ///
  /// * [stat]: The updated stat
  void updateStat(T stat) {
    //expiryTime = stat.expiryTime;
    //hitCount = stat.hitCount;
    this.stat.accessTime = stat.accessTime;
    this.stat.updateTime = stat.updateTime;
  }

  @override
  List<Object?> get props => [value];
}
