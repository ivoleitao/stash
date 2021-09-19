import 'entry.dart';
import 'stash_stat.dart';

/// The wrapper around the object that is added to the stash
class StashEntry extends Entry<StashStat> {
  /// Builds a [StashEntry]
  ///
  /// * [stat]: The entry stat
  /// * [value]: The entry value
  /// * [valueChanged]: If this value was changed
  StashEntry._(StashStat stat, dynamic value, bool? valueChanged)
      : super(stat, value, valueChanged);
}
