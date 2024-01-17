/// The stash definition
abstract class Stash<T> {
  /// The name of the stash
  String get name;

  /// The number of entries on the stash
  Future<int> get size;

  /// Returns a [Iterable] over all the [Stash] keys
  Future<Iterable<String>> get keys;

  /// Determines if the [Stash] contains an entry for the specified [key].
  ///
  /// * [key]: key whose presence in this stash is to be tested.
  ///
  /// Returns `true` if this [Stash] contains a mapping for the specified [key]
  Future<bool> containsKey(String key);

  /// Returns the stash value for the specified [key]
  ///
  /// * [key]: the key
  Future<T?> get(String key);

  /// Add / Replace the stash [value] for the specified [key].
  ///
  /// * [key]: the key
  /// * [value]: the value
  Future<void> put(String key, T value);

  /// Get the stash value for the specified [key].
  ///
  /// * [key]: the key
  Future<T?> operator [](String key);

  /// Associates the specified [key] with the given [value]
  /// if not already associated with one.
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// Returns `true` if a value was set.
  Future<bool> putIfAbsent(String key, T value);

  /// Clears the contents of the stash
  Future<void> clear();

  /// Removes the value stored under a key from this stash if present.
  ///
  /// * [key]: key whose mapping is to be removed from the stash
  Future<void> remove(String key);

  /// Associates the specified [value] with the specified [key] in this stash,
  /// and returns any existing value. If the stash previously contained
  /// a mapping for the [key], the old value is replaced by the specified value
  ///
  /// * [key]: key with which the specified value is to be associated
  /// * [value]: value to be associated with the specified key
  ///
  /// The previous value is returned, or `null` if there was no value
  /// associated with the [key] previously.
  Future<T?> getAndPut(String key, T value);

  /// Removes the entry for a [key] only if currently mapped to some value.
  ///
  /// * [key]: key with which the specified value is associated
  ///
  /// Returns the value if exists or `null` if no mapping existed for this [key]
  Future<T?> getAndRemove(String key);

  /// Closes the stash
  Future<void> close();
}

/// Extension over [Stash] to add some helper methods
extension StashExtension<T> on Stash<T> {
  /// Gets the stash values for the specified set of [keys]
  ///
  /// * [keys]: the set of keys to get
  ///
  /// Returns a map of key / value pairs
  Future<Map<String, T?>> getAll(Set<String> keys) {
    return Future.wait(keys.map((key) {
      return get(key).then((value) => MapEntry(key, value));
    })).then((value) => Map.fromEntries(value));
  }

  /// Add / Replace the stash values with the specified [map] of entries.
  ///
  /// * [map]: the map of entries to add / replace
  Future<void> putAll(Map<String, T> map) {
    return Future.wait(map.entries.map((entry) => put(entry.key, entry.value)))
        .then((value) => null);
  }

  /// Removes the values stored under a set of keys from this stash
  ///
  /// * [keys]: the set of keys to remove
  Future<void> removeAll(Set<String> keys) {
    return Future.wait(keys.map((key) => remove(key))).then((value) => null);
  }
}
