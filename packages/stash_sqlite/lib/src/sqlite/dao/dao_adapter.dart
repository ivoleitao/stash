import 'dart:typed_data';

import 'package:stash/stash_api.dart';

/// The [DaoAdapter] provides a common API for the Dao
abstract class DaoAdapter<I extends Info, E extends Entry<I>> {
  /// Counts the number of entries on a named store
  ///
  /// * [name]: The name of the store
  ///
  /// Returns the number of entries on the named store
  Future<int> count(String name);

  /// Returns all the keys on a named store
  ///
  /// * [name]: The name of the store
  ///
  /// Returns all the keys on the named store
  Future<List<String>> keys(String name);

  /// Returns the list of all headers on a named store
  ///
  /// * [name]: The name of the store
  ///
  /// Returns a [Iterable] over all [Info]s
  Future<Iterable<I>> infos(String name);

  /// Returns the list of all store entries on a named store
  ///
  /// * [name]: The name of the store
  ///
  /// Returns a [Iterable] over all [Entry]s
  Future<Iterable<E>> entries(
      String cacheName, dynamic Function(Uint8List) valueDecoder);

  /// Checks if a key exists on a named store
  ///
  /// * [name]: The name of the store
  /// * [key]: The key to check on the named store
  ///
  /// Returns true if the named store contains the provided key, false otherwise
  Future<bool> containsKey(String name, String key);

  /// Returns a store header for a key on named store
  ///
  /// * [name]: The name of the store
  /// * [key]: The key on the store
  ///
  /// Returns the named store key [Info]
  Future<I> getInfo(String name, String key);

  /// Returns the list of all store headers on a named store, filtered by the provided keys
  ///
  /// * [name]: The name of the store
  /// * [keys]: The list of keys
  ///
  /// Returns a [Iterable] over all [Info]s retrieved
  Future<Iterable<I>> getInfos(String name, Iterable<String> keys);

  /// Updates the header of a named store
  ///
  /// * [name]: The name of the store
  /// * [info]: The [Info]
  ///
  /// Returns the number of updated enties
  Future<int> updateInfo(String name, I info);

  /// Returns a cache entry for a key on named store
  ///
  /// * [name]: The name of the store
  /// * [key]: The key on the store
  /// * [valueDecoder]: The function used to convert a list of bytes to the store value
  ///
  /// Returns the named store key [Entry]
  Future<E?> getEntry(
      String name, String key, dynamic Function(Uint8List) valueDecoder);

  /// Adds a [Entry] to the named store
  ///
  /// * [name]: The name of the store
  /// * [entry]: The store entry
  /// * [valueEncoder]: The function used to serialize a object to a list of bytes
  Future<void> putEntry(
      String name, E entry, Uint8List Function(dynamic) valueEncoder);

  /// Removes a entry from a named store
  ///
  /// * [name]: The name of the store
  /// * [key]: The store key
  ///
  /// Returns the number of records updated
  Future<int> remove(String name, String key);

  /// Clears a named store
  ///
  /// * [name]: The name of the store
  ///
  /// Return the number of records updated
  Future<int> clear(String name);

  /// Deletes all caches
  ///
  /// Return the number of records updated
  Future<int> clearAll();
}
