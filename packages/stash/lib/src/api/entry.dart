import 'package:equatable/equatable.dart';
import 'package:stash/src/api/info.dart';

abstract class Entry<T extends Info> with EquatableMixin {
  /// The info
  final T info;

  /// The value
  final dynamic value;

  /// Tracks any changes to the [Entry] after obtaining it from the store
  final bool? _valueChanged;

  /// The key getter
  String get key => info.key;

  /// The creation time getter
  DateTime get creationTime => info.creationTime;

  /// The access time getter
  DateTime get accessTime => info.accessTime;

  /// The access time setter
  ///
  /// * [accessTime]: The access time
  set accessTime(DateTime accessTime) {
    info.accessTime = accessTime;
  }

  /// The update time getter
  DateTime get updateTime => info.updateTime;

  /// The update time setter
  ///
  /// * [updateTime]: The update time
  set updateTime(DateTime updateTime) {
    info.updateTime = updateTime;
  }

  /// Returns true if the value was changed after retrieval from the store or if it was newly created
  bool get valueChanged => _valueChanged ?? true;

  /// Builds a [Entry]
  ///
  /// * [value]: The entry value
  /// * [valueChanged]: If this value was changed
  Entry(this.info, this.value, this._valueChanged);

  /// Updates a [Entry] info
  ///
  /// * [info]: The updated info
  void updateInfo(T info) {
    //expiryTime = info.expiryTime;
    //hitCount = info.hitCount;
    this.info.accessTime = info.accessTime;
    this.info.updateTime = info.updateTime;
  }

  @override
  List<Object?> get props => [value];
}
