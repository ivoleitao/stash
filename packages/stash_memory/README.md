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

The example bellow creates a cache with a in-memory storage backend that supports a maximum of 10 `Task` objects.

```dart
import 'package:stash/stash_memory.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task(this.id, this.title, {this.completed = false});

  @override
  String toString() {
    return 'Task $id: "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Creates a memory based cache with a a capacity of 10
  final cache = newMemoryCache(maxEntries: 10);

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(1, 'Run stash_memory example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
```

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_memory/LICENSE) file for details