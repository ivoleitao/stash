import 'package:equatable/equatable.dart';
import 'package:stash/src/api/info.dart';

/// The state of the [Entry]
enum EntryState {
  /// The [Entry] was not changed since it's retrieval from storage
  loaded,

  /// The [Entry] is new and was not yet committed to the storage
  added,

  /// The [Entry] inf was changed since it's retrieval from storage
  updatedInfo,

  /// The [Entry] value and/or info was changed since it's retrievale from storage
  updatedValue
}

abstract class Entry<T extends Info> with EquatableMixin {
  /// The info
  final T info;

  /// The value
  final dynamic value;

  /// The state
  EntryState _state;

  /// The key getter
  String get key => info.key;

  /// The creation time getter
  DateTime get creationTime => info.creationTime;

  /// The access time getter
  DateTime get accessTime => info.accessTime;

  /// The update time getter
  DateTime get updateTime => info.updateTime;

  /// The state getter
  EntryState get state => _state;

  /// Builds a [Entry]
  ///
  /// * [info]: The entry info
  /// * [value]: The entry value
  /// * [state]: The entry state
  Entry(this.info, this.value, this._state);

  /// Updates the [Info] fields
  ///
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  void updateInfoFields({DateTime? accessTime, DateTime? updateTime}) {
    info.accessTime = accessTime ?? info.accessTime;
    info.updateTime = updateTime ?? info.updateTime;
    _state = EntryState.updatedInfo;
  }

  /// Updates a [Entry] info
  ///
  /// * [info]: The updated info
  void updateInfo(T info) {
    updateInfoFields(accessTime: info.accessTime, updateTime: info.updateTime);
  }

  @override
  List<Object?> get props => [info, value];
}
