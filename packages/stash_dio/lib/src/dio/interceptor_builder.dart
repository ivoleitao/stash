import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stash/stash_api.dart';

import 'cache_interceptor.dart';
import 'cache_value.dart';
import 'header_value.dart';

/// Function to call with the parsed header values
typedef _ParseHeadCallback = void Function(
    Duration? maxAge, Duration? maxStale);

/// A [Interceptor] builder class
class CacheInterceptorBuilder {
  /// A map of [RegExp] to [Cache] for each of he patterns
  final Map<RegExp, Cache> _cacheMap = {};

  /// The callback that will be executed before the request is initiated.
  InterceptorSendCallback get onRequest => _onRequest;

  /// The callback that will be executed on success.
  InterceptorSuccessCallback get onResponse => _onResponse;

  /// The callback that will be executed on error.
  InterceptorErrorCallback get onError => _onError;

  /// Registers a [Cache] under a specific pattern
  ///
  /// * [pattern]: The pattern
  /// * [cache]: The cache
  void cache(String pattern, Cache cache) {
    _cacheMap[RegExp(pattern)] = cache;
  }

  /// Returns a [Cache] for the current [Uri] or null if none was configured
  ///
  /// * [uri]: The [Uri] being called
  ///
  /// Returns the [Cache] if any
  Cache? _getCache(Uri uri) {
    final input = '${uri.host}${uri.path}?${uri.query}';
    for (var entry in _cacheMap.entries) {
      if (entry.key.hasMatch(input)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Converts bytes to a hexadecimal string
  ///
  /// * [bytes]: The bytes
  ///
  /// Return the hexadecimal string
  String _hex(List<int> bytes) {
    final buffer = StringBuffer();
    for (var part in bytes) {
      if (part & 0xff != part) {
        throw FormatException('$part is not a byte integer');
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return buffer.toString().toUpperCase();
  }

  /// Creates a MD5 out of String
  ///
  /// * [input]: The input string
  ///
  /// Return the MD5 hash of string
  String _toMd5(String input) {
    return _hex(md5.convert(utf8.encode(input)).bytes);
  }

  /// Returns the key for the current [RequestOptions]
  ///
  /// * [options]: The [RequestOptions]
  ///
  /// Returns the key
  String _getKey(RequestOptions options) => _toMd5(
      '${options.uri.host}${options.uri.path}?${options.uri.query}_${options.data.toString()}');

  /// Builds a [Response] out of [CacheValue]
  ///
  /// * [value]: The [CacheValue]
  /// * [options]: The [RequestOptions]
  ///
  /// Returns a [Response]
  Response _responseFromCacheValue(CacheValue value, RequestOptions options) {
    Headers? headers;
    if (value.headers != null) {
      headers = Headers.fromMap((Map<String, List<dynamic>>.from(
              jsonDecode(utf8.decode(value.headers!))))
          .map((k, v) => MapEntry(k, List<String>.from(v))));
    }

    if (headers == null) {
      headers = Headers();
      options.headers.forEach((k, v) => headers!.add(k, v ?? ''));
    }

    dynamic data = value.data;

    if (options.responseType != ResponseType.bytes) {
      data = jsonDecode(utf8.decode(data));
    }

    return Response(
        data: data,
        headers: headers,
        requestOptions: options,
        statusCode: value.statusCode ?? 200);
  }

  /// Intercepts a request and checks if it's present on the cache
  ///
  /// * [options]: The [RequestOptions]
  /// * [handler]: The [RequestInterceptorHandler]
  ///
  /// Returns the response after a HTTP request or the cached response if
  /// available on cache
  void _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final cache = _getCache(options.uri);
    if (cache != null) {
      final value = await cache.get(_getKey(options));
      if (value != null) {
        handler.resolve(
            _responseFromCacheValue(
                value is CacheValue ? value : CacheValue.fromJson(value),
                options),
            false);
        return;
      }
    }

    handler.next(options);
  }

  /// Parses a duration out of a parameter map
  ///
  /// * [parameters]: The parameters
  /// * [key]: The key of the parameter to extract
  ///
  /// Returns the [Duration] if available or null is not available
  Duration? _tryGetDurationFromMap(
      Map<String, String?>? parameters, String key) {
    if (null != parameters && parameters.containsKey(key)) {
      final value = int.tryParse(parameters[key]!);
      if (value != null && value >= 0) {
        return Duration(seconds: value);
      }
    }
    return null;
  }

  /// Parses the response header
  ///
  /// * [response]: The [Response]
  /// * [callback]: A callback to invoke upon sucessfull parsing
  void _tryParseHead(Response response, _ParseHeadCallback callback) {
    Duration? maxAge;
    Duration? maxStale;
    final cacheControlList = response.headers['cache-control'];
    if (cacheControlList != null) {
      // Collate all the cache control headers into a valid string
      final cacheControl = cacheControlList.join(',');
      // try to get maxAge and maxStale from cacheControl
      final parameters = HeaderValue.parseCacheControl(cacheControl).parameters;
      maxAge = _tryGetDurationFromMap(parameters, 's-maxage');
      maxAge ??= _tryGetDurationFromMap(parameters, 'max-age');
      // if staleTime has value, don't get max-stale anymore.
      maxStale ??= _tryGetDurationFromMap(parameters, 'max-stale');
    } else {
      // try to get expiryTime from expires
      final expires = response.headers.value('expires');
      if (expires != null && expires.length > 4) {
        final endTime = parseHttpDate(expires).toLocal();
        if (endTime.compareTo(DateTime.now()) >= 0) {
          maxAge = endTime.difference(DateTime.now());
        }
      }
    }

    callback(maxAge, maxStale);
  }

  /// Intercepts the received from a HTTP call and stores on cache
  ///
  /// * [response]: The [Response]
  /// * [handler]: The [RequestInterceptorHandler]
  ///
  /// Returns [Response] after the interception
  void _onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final cache = _getCache(response.requestOptions.uri);
      if (cache != null) {
        final options = response.requestOptions;
        Duration? maxAge;
        DateTime? staleDate;
        if (maxAge == null) {
          _tryParseHead(response, (_maxAge, _staleTime) {
            maxAge = _maxAge;
            staleDate =
                _staleTime != null ? DateTime.now().add(_staleTime) : null;
          });
        }

        List<int>? data;
        if (options.responseType == ResponseType.bytes) {
          data = response.data;
        } else {
          data = utf8.encode(jsonEncode(response.data));
        }

        await cache.put(
            _getKey(options),
            CacheValue(
                statusCode: response.statusCode,
                headers: utf8.encode(jsonEncode(response.headers.map)),
                staleDate: staleDate,
                data: data), delegate: (CacheEntryBuilder builder) {
          if (maxAge != null) {
            builder.expiryDuration = maxAge!;
          }

          return builder;
        });
      }
    }

    handler.next(response);
  }

  /// Intercepts the call triggered upon error and returns if available the
  /// cached response
  ///
  /// * [e]: The [DioError]
  /// * [handler]: The [ErrorInterceptorHandler]
  ///
  /// Returns the error
  void _onError(DioError e, ErrorInterceptorHandler handler) async {
    final cache = _getCache(e.requestOptions.uri);
    if (cache != null) {
      final value = (await cache.get(_getKey(e.requestOptions))) as CacheValue?;

      if (value != null && !value.staleDateExceeded()) {
        handler.resolve(_responseFromCacheValue(value, e.requestOptions));
      }
    }

    handler.next(e);
  }

  /// Builds the [Interceptor]
  Interceptor build() {
    return CacheInterceptor.builder(this);
  }
}
