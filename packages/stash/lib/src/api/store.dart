import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../msgpack/codec.dart';
import 'codec/store_codec.dart';
import 'entry.dart';
import 'info.dart';

/// Value processor
enum ValueProcessor {
  /// No processing
  none,

  /// Cast to a binary list
  cast,

  /// Custom
  custom
}

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

  /// Closes a store
  Future<void> close();
}

/// A definition of a stores that persists data
abstract class PersistenceStore<I extends Info, E extends Entry<I>>
    extends Store<I, E> {
  /// The store codec to use
  @protected
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
  @protected
  dynamic Function(Map<String, dynamic>)? decoder(String name) {
    return _fromEncodables[name];
  }

  /// Encodes a value into a list of bytes
  ///
  /// * [value]: The value to encode
  ///
  /// Returns the value encoded as a list of bytes
  @protected
  Uint8List encodeValue(dynamic value) {
    final writer = codec.encoder();

    writer.write(value);

    return writer.takeBytes();
  }

  /// Returns a value decoded from the provided binary value
  ///
  /// * [bytes]: The list of bytes
  /// * [fromEncodable]: An function that converts between the Map representation and the object
  ///
  /// Returns decoded value from the provided binary value
  @protected
  dynamic decodeBinaryValue(
      Uint8List bytes, dynamic Function(Map<String, dynamic>)? fromEncodable) {
    final reader =
        codec.decoder(Uint8List.fromList(bytes), fromEncodable: fromEncodable);

    return reader.read();
  }

  /// Returns a value decoded from the provided value
  ///
  /// * [bytes]: The list of bytes
  /// * [fromEncodable]: An function that converts between the Map representation and the object
  /// * [processor]: The value transformation to apply if any
  /// * [process]: A transformer function
  ///
  /// Returns the decoded value from the provided value
  @protected
  dynamic decodeValue(
      dynamic value, dynamic Function(Map<String, dynamic>)? fromEncodable,
      {ValueProcessor processor = ValueProcessor.none,
      List<int> Function(dynamic)? process}) {
    List<int> bytes;
    if (processor == ValueProcessor.custom && process != null) {
      bytes = process(value);
    } else if (processor == ValueProcessor.cast) {
      bytes = (value as List).cast<int>();
    }  else {
      if(value is String) {
        return value;
      } else if(value is Map && fromEncodable!=null) {
        return fromEncodable(value.cast<String, dynamic>());
      } else {
        bytes = value as List<int>;
      }
    }

    return decodeBinaryValue(Uint8List.fromList(bytes), fromEncodable);
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
