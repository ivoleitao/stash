# stash

The base `stash` library.

[![Pub Package](https://img.shields.io/pub/v/stash.svg?style=flat-square)](https://pub.dartlang.org/packages/stash)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash-blue.svg)](https://www.dartdocs.org/documentation/stash/latest)

## Overview

This package provides the foundations of the `stash` caching library upon which specific implementations of storage mechanisms and 3rd party library integrations rely upon. It sports a in-memory implementation that is perfictly suitable for the majority of the use cases providing a rather efficient way of avoiding repeatable calls to heavyweight resources.

## Getting Started

Add this to your `pubspec.yaml` replacing `x.x.x` with the latest version of the `stash` library

```dart
dependencies:
    stash: ^x.x.x
```

Run the following command to install dependencies:

```dart
pub get
```

Optionally use the following command to run the tests:

```dart
pub run test
```

Finally, to start developing import the library:

```dart
import 'package:stash/stash_memory.dart';
```

## Usage

The example bellow creates a cache with a in-memory storage backend that supports a maximum of 10 `Task` objects. In this rather simple example there is no need to provide methods to serialize/deserialize the object as the object stays in-memory. Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information about the available APIs and to explore the full range of capabilities of the `stash` library

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