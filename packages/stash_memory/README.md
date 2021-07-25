# stash_memory
A [stash](https://github.com/ivoleitao/stash) in-memory storage extension for 

[![Pub Package](https://img.shields.io/pub/v/stash_memory.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_memory)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_memory)](https://codecov.io/gh/ivoleitao/stash_memory)
[![Package Documentation](https://img.shields.io/badge/doc-stash_memory-blue.svg)](https://www.dartdocs.org/documentation/stash_memory/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides in-memory based storage.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_memory: 

```dart
dependencies:
    stash_memory: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_memory/stash_memory.dart';
```

## Usage

The example bellow creates two caches with a shared in-memory storage backend. Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information and to explore the full range of capabilities of the `stash` library

```dart
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  @override
  String toString() {
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Creates a store
  final store = newMemoryStore();
  // Creates a cache with a capacity of 10 from the previously created store
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the first cache'));
  // Creates a third cache with a capacity of 10 from the previously created store
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

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_memory/LICENSE) file for details