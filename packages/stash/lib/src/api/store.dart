import 'entry.dart';
import 'stat.dart';

/// Store definition
abstract class Store<S extends Stat, E extends Entry<S>> {
  /// The number of entries in the store
  ///
  /// * [name]: The store name
  Future<int> size(String name);

  /// Returns a [Iterable] over all the store keys
  ///
  /// * [name]: The store name
  Future<Iterable<String>> keys(String name);

  /// Returns a [Iterable] over all the stats for a named store.
  ///
  /// * [name]: The store name
  Future<Iterable<S>> stats(String name);

  /// Returns a [Iterable] over all the non nullable stats
  /// from the requested keys.
  ///
  /// * [name]: The store name
  /// * [keys]: The list of keys
  Future<Iterable<S?>> getStats(String name, Iterable<String> keys);

  /// Returns a [Iterable] over all entre of a named store.
  ///
  /// * [name]: The store name
  Future<Iterable<E>> values(String name);

  /// Checks if the named store contains a value indexed by [key]
  ///
  /// * [name]: The store name
  /// * [key]: The store value key
  Future<bool> containsKey(String name, String key);

  /// Returns the stat for the specified [key].
  ///
  /// * [name]: The store name
  /// * [key]: The store value key
  Future<S?> getStat(String name, String key);

  /// Sets the store stat by [name] and [key].
  ///
  /// * [name]: The store name
  /// * [key]: The store key
  /// * [stat]: The stat
  Future<void> setStat(String name, String key, S stat);

  /// Returns the entry for the named store value specified by the [key].
  ///
  /// * [name]: The store name
  /// * [key]: The store key
  Future<E?> getEntry(String name, String key);

  /// Puts an entry identified by [key] on the named store.
  /// The value is overriden if already exists or added if it does not exists.
  ///
  /// * [name]: The store name
  /// * [key]: The store value key
  /// * [entry]: The entry
  Future<void> putEntry(String name, String key, E entry);

  /// Removes the stored entry for the specified [key].
  ///
  /// * [name]: The store name
  /// * [key]: The store value key
  Future<void> remove(String name, String key);

  /// Clears a named store
  ///
  /// * [name]: The store name
  Future<void> clear(String name);

  /// Deletes a named store
  ///
  /// * [name]: The store name
  Future<void> delete(String name);

  /// Deletes the store
  Future<void> deleteAll();
}
