# stash_dio
A [stash](https://github.com/ivoleitao/stash) Dio extension

[![Pub Package](https://img.shields.io/pub/v/stash_dio.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_dio)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_dio)](https://codecov.io/gh/ivoleitao/stash_dio)
[![Package Documentation](https://img.shields.io/badge/doc-stash_dio-blue.svg)](https://www.dartdocs.org/documentation/stash_dio/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This integration of [stash](https://pub.dartlang.org/packages/stash) with [dio](https://pub.dev/packages/dio) provides a caching interceptor that is able to return the response from a Cache instead of hitting the backend system.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_dio:

```dart
dependencies:
    stash_dio: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_dio/stash_dio.dart';
```

## Usage

```dart
import 'package:dio/dio.dart';
import 'package:stash_dio/stash_dio.dart';
import 'package:stash_memory/stash_memory.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  /// Creates a [Task] from json map
  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool);

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'completed': completed};

  @override
  String toString() {
    return 'Task $id: "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Creates a store
  final store = newMemoryStore();
  // Configures a a dio client
  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'))
    ..interceptors.addAll([
      newMemoryCacheInterceptor('/todos/1', 'task', store: store),
      LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false)
    ]);

  // First call, executes the request and response is received
  final task1 = await dio
      .get('/todos/1')
      .then((Response<dynamic> response) => Task.fromJson(response.data));
  print(task1);

  // Second call, executes the request and the response is received from the
  // cache
  final task2 = await dio
      .get('/todos/1')
      .then((Response<dynamic> response) => Task.fromJson(response.data));
  print(task2);
}
```

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash_dio/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_dio/LICENSE) file for details