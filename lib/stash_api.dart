/// Standard caching API for Dart. Defines a common mechanism to create,
/// access, update, and remove information from caches.
library stash_api;

import 'package:stash/src/api/cache.dart';
import 'package:stash/src/api/cache/tiered_cache.dart';

export 'src/api/cache.dart';
export 'src/api/cache_codec.dart';
export 'src/api/cache_entry.dart';
export 'src/api/cache_stat.dart';
export 'src/api/cache_store.dart';
export 'src/api/codec/bytes_reader.dart';
export 'src/api/codec/bytes_util.dart';
export 'src/api/codec/bytes_writer.dart';
export 'src/api/codec/msgpack/codec.dart';
export 'src/api/eviction/eviction_policy.dart';
export 'src/api/eviction/fifo_policy.dart';
export 'src/api/eviction/filo_policy.dart';
export 'src/api/eviction/lfu_policy.dart';
export 'src/api/eviction/lru_policy.dart';
export 'src/api/eviction/mfu_policy.dart';
export 'src/api/eviction/mru_policy.dart';
export 'src/api/expiry/accessed_policy.dart';
export 'src/api/expiry/created_policy.dart';
export 'src/api/expiry/eternal_policy.dart';
export 'src/api/expiry/expiry_policy.dart';
export 'src/api/expiry/modified_policy.dart';
export 'src/api/expiry/touched_policy.dart';
export 'src/api/sampler/full_sampler.dart';
export 'src/api/sampler/sampler.dart';

/// Creates a new [TieredCache] with a primary and secondary [Cache] instances
///
/// * [primary]: The primary cache
/// * [secondary]: The secondary cache
///
/// Returns a [Cache] backed by a [TieredCache]
Cache newTieredCache(Cache primary, Cache secondary) {
  return Cache.newTieredCache(primary, secondary);
}
