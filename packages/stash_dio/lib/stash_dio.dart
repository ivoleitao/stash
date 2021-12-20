/// A cache extension for Dio using the stash caching library
library stash_dio;

import 'package:dio/dio.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_dio/src/dio/interceptor_builder.dart';

export 'src/dio/cache_interceptor.dart';

/// Creates a new [Interceptor] backed by the provided [Cache]
///
/// * [pattern]: All the calls with a url matching this pattern will be cached
///
/// Returns a [Interceptor]
Interceptor _newCacheInterceptor(String pattern, Cache cache) {
  return (CacheInterceptorBuilder()..cache(pattern, cache)).build();
}

extension InterceptorExtension on Cache {
  /// Creates a new [Interceptor] backed by a [Cache]
  ///
  /// * [pattern]: All the calls with a url matching this pattern will be cached
  ///
  /// Returns a [Interceptor] backed by a [Cache]
  Interceptor interceptor(String pattern) {
    return _newCacheInterceptor(pattern, this);
  }
}
