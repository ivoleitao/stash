# stash_isar
A [stash](https://github.com/ivoleitao/stash) storage extension for [isar](https://pub.dev/packages/isar)

[![Pub Package](https://img.shields.io/pub/v/stash_isar.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_isar)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_isar)](https://codecov.io/gh/ivoleitao/stash_isar)
[![Package Documentation](https://img.shields.io/badge/doc-stash_isar-blue.svg)](https://www.dartdocs.org/documentation/stash_isar/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a 
[isar](https://pub.dev/packages/isar) based storage that relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_isar:

```dart
dependencies:
    stash_isar: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_isar/stash_isar.dart';
```

## Usage

The example bellow creates two caches with a isar storage backend. In this rather simple example the serialization and deserialization of the object is coded by hand but it's more usual to rely on libraries like [json_serializable](https://pub.dev/packages/json_serializable). Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information and to explore the full range of capabilities of the `stash` library

```dart
import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_isar/stash_isar.dart';

class Task {
  final int? id;
  final String? title;
  final bool? completed;

  Task({this.id, this.title, this.completed = false});

  /// Creates a [Task] from json map
  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int?,
      title: json['title'] as String?,
      completed: json['completed'] as bool?);

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'completed': completed};

  @override
  String toString() {
    return 'Task $id: "$title" is ${completed! ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary path
  final path = Directory.systemTemp.path;

  // Creates a store
  final store =
      newIsarStore(path: path, fromEncodable: (json) => Task.fromJson(json));
  // Creates a cache with a capacity of 10 from the previously created store
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the first cache'));
  // Creates a second cache with a capacity of 10 from the previously created store
  final cache2 = store.cache(
      cacheName: 'cache2',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the second cache'));

  // Adds a task with key 'task1' to the first cache
  await cache1.put('task1',
      Task(id: 1, title: 'Run shared store example (1)', completed: true));
  // Retrieves the value from the first cache
  print(await cache1.get('task1'));

  // Adds a task with key 'task1' to the second cache
  await cache2.put('task1',
      Task(id: 2, title: 'Run shared store example (2)', completed: true));
  // Retrieves the value from the second cache
  print(await cache2.get('task1'));
}

```

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_isar/LICENSE) file for details