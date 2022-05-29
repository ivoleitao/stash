import 'entry.dart';
import 'info.dart';

/// Store definition
abstract class Store<I extends Info, E extends Entry<I>> {
  /// Creates a partition
  ///
  /// * [name]: The partition name
  Future<void> create(String name);

  /// The number of entries in the partition
  ///
  /// * [name]: The partition name
  Future<int> size(String name);

  /// Returns a [Iterable] over all the keys
  ///
  /// * [name]: The partition name
  Future<Iterable<String>> keys(String name);

  /// Returns a [Iterable] over all the infos in the partition.
  ///
  /// * [name]: The partition name
  Future<Iterable<I>> infos(String name);

  /// Returns a [Iterable] over all the non nullable infos in a partition
  ///
  /// * [name]: The partition name
  /// * [keys]: The list of keys
  Future<Iterable<I?>> getInfos(String name, Iterable<String> keys);

  /// Returns a [Iterable] over all entries in a partition
  ///
  /// * [name]: The store name
  Future<Iterable<E>> values(String name);

  /// Checks if the partition contains a value indexed by [key]
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<bool> containsKey(String name, String key);

  /// Returns the info for the specified [key] in a partition.
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<I?> getInfo(String name, String key);

  /// Sets the partition info indexed by [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  /// * [info]: The info
  Future<void> setInfo(String name, String key, I info);

  /// Returns the partition entry specified by [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  Future<E?> getEntry(String name, String key);

  /// Puts an entry identified by [key] on a partition.
  /// The value is overriden if already exists or added if it does not exists.
  ///
  /// * [name]: The partition name
  /// * [key]: The key
  /// * [entry]: The entry
  Future<void> putEntry(String name, String key, E entry);

  /// Removes the partition entry by [key].
  ///
  /// * [name]: The partition name
  /// * [key]: The partition key
  Future<void> remove(String name, String key);

  /// Clears a partition
  ///
  /// * [name]: The partition name
  Future<void> clear(String name);

  /// Deletes a partition
  ///
  /// * [name]: The partition name
  Future<void> delete(String name);

  /// Deletes all partitions
  Future<void> deleteAll();
}
