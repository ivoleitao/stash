/// Provides a Objectbox implementation of the Stash caching API for Dart
library stash_objectbox;

import 'package:stash/stash.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_adapter.dart';
import 'package:stash_objectbox/src/objectbox/objectbox_store.dart';

export 'src/objectbox/objectbox_adapter.dart';
export 'src/objectbox/objectbox_store.dart';

/// Creates a new [Cache] backed by a [ObjectboxStore]
///
/// * [path]: The base storage location for this cache
/// * [cacheName]: The name of the cache
/// * [expiryPolicy]: The expiry policy to use, defaults to [EternalExpiryPolicy] if not provided
/// * [sampler]: The sampler to use upon eviction of a cache element, defaults to [FullSampler] if not provided
/// * [evictionPolicy]: The eviction policy to use, defaults to [LfuEvictionPolicy] if not provided
/// * [maxEntries]: The max number of entries this cache can hold if provided. To trigger the eviction policy this value should be provided
/// * [cacheLoader]: The [CacheLoader] that should be used to fetch a new value upon expiration
/// * [codec]: The [CacheCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
/// * [fromEncodable]: A custom function the converts to the object from a `Map<String, dynamic>` representation
/// * [path]: The base location of the Objectbox storage
/// * [maxDBSizeInKB]: The max DB size
/// * [fileMode]: The file mode
/// * [maxReaders]: The number of maximum readers
/// * [queriesCaseSensitiveDefault]: If the queries are case sensitive, the default is true
///
/// Returns a new [Cache] backed by a [ObjectboxStore]
Cache newObjectBoxCache(String path,
    {String? cacheName,
    ExpiryPolicy? expiryPolicy,
    KeySampler? sampler,
    EvictionPolicy? evictionPolicy,
    int? maxEntries,
    CacheLoader? cacheLoader,
    CacheCodec? codec,
    dynamic Function(dynamic)? fromEncodable,
    int? maxDBSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool? queriesCaseSensitiveDefault}) {
  return Cache.newCache(
      ObjectboxStore(
          ObjectboxAdapter(path,
              maxDBSizeInKB: maxDBSizeInKB,
              fileMode: fileMode,
              maxReaders: maxReaders,
              queriesCaseSensitiveDefault: queriesCaseSensitiveDefault),
          codec: codec,
          fromEncodable: fromEncodable),
      name: cacheName,
      expiryPolicy: expiryPolicy,
      sampler: sampler,
      evictionPolicy: evictionPolicy,
      maxEntries: maxEntries,
      cacheLoader: cacheLoader);
}
