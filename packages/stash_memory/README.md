# stash_memory
A [stash](https://github.com/ivoleitao/stash) in-memory storage extension 

[![Pub Package](https://img.shields.io/pub/v/stash_memory.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_memory)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_memory)](https://codecov.io/gh/ivoleitao/stash_memory)
[![Package Documentation](https://img.shields.io/badge/doc-stash_memory-blue.svg)](https://www.dartdocs.org/documentation/stash_memory/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Storage extension for [stash](https://pub.dartlang.org/packages/stash) which provides in-memory based storage.

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

Finally, to start developing import the following libraries:

```dart
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';
```

## Usage

### Vault

The example bellow creates a vault with a in-memory storage backend. 

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
  final store = await newMemoryVaultStore();

  // Creates a vault from the previously created store
  final vault = await store.vault<Task>(
      name: 'vault', eventListenerMode: EventListenerMode.synchronous)
    ..on<VaultEntryCreatedEvent<Task>>().listen(
        (event) => print('Key "${event.entry.key}" added to the vault'));

  // Adds a task with key 'task1' to the vault
  await vault.put(
      'task1', Task(id: 1, title: 'Run vault store example', completed: true));
  // Retrieves the value from the vault
  print(await vault.get('task1'));
}
```

### Cache

The example bellow creates a cache with a in-memory storage backend. 

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
  final store = await newMemoryCacheStore();

  // Creates a cache with a capacity of 10 from the previously created store
  final cache = await store.cache<Task>(
      name: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CacheEntryCreatedEvent<Task>>().listen(
        (event) => print('Key "${event.entry.key}" added to the cache'));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(id: 1, title: 'Run cache store example', completed: true));
  // Retrieves the value from the cache
  print(await cache.get('task1'));
}
```

### Additional Features

Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information and to explore the full range of capabilities of the `stash` library

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_memory/LICENSE) file for details