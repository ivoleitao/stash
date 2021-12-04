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

  /// The type getter
  int get type => info.type;

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

/// The [Entry] builder
abstract class EntryBuilder<T extends Info, E extends Entry<T>> {
  /// The key
  final String key;

  /// The value
  final dynamic value;

  /// The creation time
  final DateTime creationTime;

  /// The state
  final EntryState state;

  /// The type
  int type;

  /// Builds a [EntryBuilder]
  ///
  /// * [key]: The entry key
  /// * [value]: The entry value
  /// * [creationTime]: The entry creation time
  /// * [state]: The entry state
  /// * [type]: The entry type
  EntryBuilder(this.key, this.value, this.creationTime, {int? type})
      : state = EntryState.added,
        type = type ?? 0;

  /// Builds an [Entry]
  E build();
}
