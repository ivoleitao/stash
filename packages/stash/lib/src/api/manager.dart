import 'package:stash/src/api/stash.dart';

abstract class StashManager {
  /// Returns a [Iterable] over all the [Stash] names
  Iterable<String> get names;

  /// Removes a [Stash] from this [StashManager] if present
  ///
  /// * [name]: The name of the cache
  void remove(String name);
}
