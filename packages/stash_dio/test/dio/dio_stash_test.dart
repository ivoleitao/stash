import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stash_dio/src/dio/cache_value.dart';
import 'package:stash_dio/src/dio/interceptor_builder.dart';
import 'package:stash_file/stash_file.dart';
import 'package:stash_memory/stash_memory.dart';
import 'package:test/test.dart';

const baseUrl = 'https://jsonplaceholder.typicode.com';

class _DioAdapterMock extends Mock implements HttpClientAdapter {}

class Post {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Post({this.userId, this.id, this.title, this.body});

  Post._a(
      {int userId = 1,
      int id = 1,
      title = 'sunt aut facere repellat provident occaecati',
      body = 'quia et suscipit\nsuscipit recusandae consequuntur'})
      : this(userId: userId, id: id, title: title, body: body);

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'id': id,
        'title': title,
        'body': body
      };
}

class RequestOptionsFake extends Fake implements RequestOptions {}

void withInterceptor(
    Dio dio,
    CacheInterceptorBuilder Function(CacheInterceptorBuilder builder)
        buildWith) {
  dio.interceptors.add(buildWith(CacheInterceptorBuilder()).build());
}

Map<String, dynamic>? _withAnswer(_DioAdapterMock mock, dynamic obj,
    {int statusCode = 200,
    Map<String, List<String>> headers = const <String, List<String>>{}}) {
  Map<String, dynamic>? response = obj.toJson();

  var responseBody =
      ResponseBody.fromString(json.encode(response), statusCode, headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...headers
  });

  when(() => mock.fetch(captureAny(), captureAny(), captureAny()))
      .thenAnswer((_) => Future.value(responseBody));

  return response;
}

dynamic _getResponse(Dio dio, String path) async {
  return await dio.get(path).then((response) => response.data);
}

void main() async {
  late Dio dio;
  late _DioAdapterMock dioAdapterMock;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapterMock = _DioAdapterMock();
    dio.httpClientAdapter = dioAdapterMock;

    registerFallbackValue<RequestOptions>(RequestOptionsFake());
  });

  test('CacheValue serialization/deserialization with no values', () async {
    final cacheValue1 = CacheValue();
    final cacheValueSerialized = cacheValue1.toJson();
    final cacheValue2 = CacheValue.fromJson(cacheValueSerialized);

    expect(cacheValue1, equals(cacheValue2));
  });

  test('CacheValue serialization/deserialization with all values', () async {
    final headers = utf8.encode(jsonEncode({
      'a': ['1', 's']
    }));
    final data = utf8.encode(jsonEncode('test'));

    final cacheValue1 = CacheValue(
        statusCode: 200,
        headers: headers,
        staleDate: DateTime(2000, 1, 1, 1, 1, 1, 1, 1),
        data: data);
    final cacheValueSerialized = cacheValue1.toJson();
    final cacheValue2 = CacheValue.fromJson(cacheValueSerialized);

    expect(cacheValue1, equals(cacheValue2));
  });

  test('Without cache', () async {
    final providedResponse = _withAnswer(dioAdapterMock, Post._a());
    final receivedResponse = await _getResponse(dio, '/posts/1');

    expect(receivedResponse, providedResponse);
  });

  test('Without cache setting two different responses', () async {
    var providedResponse1 = _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse1 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse1, providedResponse1);

    var providedResponse2 = _withAnswer(dioAdapterMock, Post._a(userId: 2));
    var receivedResponse2 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse2, providedResponse2);
  });

  test('With cache setting two different responses', () async {
    withInterceptor(
        dio, (builder) => builder..cache('/posts/1', newMemoryCache()));
    var providedResponse1 = _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse1 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse1, providedResponse1);

    _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse2 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse2, providedResponse1);
  });

  test('With cache but not matching the request', () async {
    withInterceptor(
        dio, (builder) => builder..cache('/posts/1', newMemoryCache()));
    var providedResponse1 = _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse1 = await _getResponse(dio, '/posts/2');

    expect(receivedResponse1, providedResponse1);

    var providedResponse2 = _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse2 = await _getResponse(dio, '/posts/2');

    expect(receivedResponse2, providedResponse2);
  });

  test('With cache but with status code out of the allowed range', () async {
    withInterceptor(
        dio, (builder) => builder..cache('/posts/1', newMemoryCache()));
    _withAnswer(dioAdapterMock, Post._a(), statusCode: 404);
    expect(
        _getResponse(dio, '/posts/1'), throwsA(const TypeMatcher<DioError>()));
  });

  test('With a file cache', () async {
    withInterceptor(
        dio, (builder) => builder..cache('/posts/1', newMemoryFileCache()));
    var providedResponse1 = _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse1 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse1, providedResponse1);

    _withAnswer(dioAdapterMock, Post._a());
    var receivedResponse2 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse2, providedResponse1);
  }, testOn: '!js');

  test('stash-dio #14', () async {
    withInterceptor(
        dio, (builder) => builder..cache('/posts/1', newMemoryCache()));
    var providedResponse1 = _withAnswer(dioAdapterMock, Post._a(), headers: {
      'cache-control': ['no-cache', 'no-store']
    });
    var receivedResponse1 = await _getResponse(dio, '/posts/1');

    expect(receivedResponse1, providedResponse1);
  });
}
