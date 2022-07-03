import 'package:meta/meta.dart';

import '../msgpack/codec.dart';
import 'codec/store_codec.dart';
import 'entry.dart';
import 'info.dart';

/// Store definition
abstract class Store<I extends Info, E extends Entry<I>> {
  /// Creates a partition
  ///
  /// * [name]: The partition name
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  Future<void> create(String name,
      {dynamic Function(Map<String, dynamic>)? fromEncodable});

  /// The number of entries in the partition
  ///
  /// * [name]: The partition name
  Future<int> size(String name);

  /// Returns a [Iterable] over all the keys in the partition
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

/// A definition of a stores that persists data
abstract class PersistenceStore<I extends Info, E extends Entry<I>>
    extends Store<I, E> {
  @protected

  /// The store codec to use
  final StoreCodec codec;

  /// Creates a [PersistenceStore].
  ///
  /// * [codec]: The [StoreCodec] used to convert to/from a
  /// Map<String, dynamic>` representation to a binary representation.
  PersistenceStore({StoreCodec? codec}) : codec = codec ?? const MsgpackCodec();

  /// Map of fromEncodable functions per partition
  final Map<String, dynamic Function(Map<String, dynamic>)> _fromEncodables =
      {};

  /// Gets the partition `fromEncodable` function
  ///
  /// * [name]: The partition name
  dynamic Function(Map<String, dynamic>)? decoder(String name) {
    return _fromEncodables[name];
  }

  /// Decodes a value
  ///
  /// * [value]: The value to decode
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  /// * [mapFn]: A optional function that maps the value
  /// * [defaultFn]: A optional function that obtains the value to use in
  /// case there is no `fromEncodable` function for the partition
  dynamic decodeValue(
      dynamic value, dynamic Function(Map<String, dynamic>)? fromEncodable,
      {dynamic Function(dynamic)? mapFn, dynamic Function()? defaultFn}) {
    if (value == null) {
      return null;
    }

    if (fromEncodable != null) {
      return fromEncodable(mapFn != null ? mapFn(value) : value);
    } else if (defaultFn != null) {
      return defaultFn();
    }

    return value;
  }

  /// Creates a partition
  ///
  /// * [name]: The partition name
  /// * [fromEncodable]: The function that converts between the Map representation of the object and the object itself.
  @override
  Future<void> create(String name,
      {dynamic Function(Map<String, dynamic>)? fromEncodable}) {
    if (fromEncodable != null) {
      _fromEncodables[name] = fromEncodable;
    }

    return Future.value();
  }
}
