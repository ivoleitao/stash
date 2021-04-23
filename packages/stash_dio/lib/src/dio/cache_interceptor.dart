import 'package:dio/dio.dart';

import 'interceptor_builder.dart';

/// A implementation of the [InterceptorsWrapper] providing a Cache interceptor
class CacheInterceptor extends InterceptorsWrapper {
  /// Builds a [CacheInterceptor]
  ///
  /// * [onRequest]: The callback that will be executed before the request is initiated.
  /// * [onResponse]: The callback that will be executed on success.
  /// * [onError]: The callback that will be executed on error.
  CacheInterceptor._({
    InterceptorSendCallback? onRequest,
    InterceptorSuccessCallback? onResponse,
    InterceptorErrorCallback? onError,
  }) : super(onRequest: onRequest, onResponse: onResponse, onError: onError);

  /// Builds a [CacheInterceptor] out of a [CacheInterceptorBuilder]
  ///
  /// * [builder]: The [CacheInterceptorBuilder]
  CacheInterceptor.builder(CacheInterceptorBuilder builder)
      : this._(
            onRequest: builder.onRequest,
            onResponse: builder.onResponse,
            onError: builder.onError);
}
