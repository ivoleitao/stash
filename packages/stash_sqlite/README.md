# stash_sqlite
A [stash](https://github.com/ivoleitao/stash) storage extension for sqlite using the [drift](https://pub.dev/packages/drift) package

[![Pub Package](https://img.shields.io/pub/v/stash_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sqlite)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_sqlite)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash_sqlite-blue.svg)](https://www.dartdocs.org/documentation/stash_sqlite/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a storage layer through the [drift](https://pub.dev/packages/drift) persistent library and relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format. This storage backend is particularly optimized to support cache features, like expiration and eviction which are highly dependent on the update of control fields on the entries upon user operations. On this storage backend the update of those fields does not cause the update of the whole cache entry as some of the other storage implementations like [stash_hive](https://pub.dartlang.org/packages/stash_hive) or [stash_sembast](https://pub.dartlang.org/packages/stash_sembast) since they are stored in specific columns on the relational database model.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_sqlite:

```dart
dependencies:
    stash_sqlite: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';
```

## Usage

### Vault

The example bellow creates a vault with a shared sqlite storage backend. In this rather simple example the serialization and deserialization of the object is coded by hand but it's more usual to rely on libraries like [json_serializable](https://pub.dev/packages/json_serializable).


```dart
import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

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
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary directory
  final dirPath = Directory.systemTemp;
  // Temporary database file for a shared store
  final file = File('${dirPath.path}/stash_sqlite.sdb');

  // Creates a store
  final store = await newSqliteLocalVaultStore(file: file);

  // Creates a vault from the previously created store
  final vault = await store.vault<Task>(
      name: 'vault', 
      fromEncodable: (json) => Task.fromJson(json),
      eventListenerMode: EventListenerMode.synchronous)
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

The example bellow creates a cache with a shared sqlite storage backend. In this rather simple example the serialization and deserialization of the object is coded by hand but it's more usual to rely on libraries like [json_serializable](https://pub.dev/packages/json_serializable).

```dart
import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

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
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary directory
  final dirPath = Directory.systemTemp;
  // Temporary database file for a shared store
  final file = File('${dirPath.path}/stash_sqlite.sdb');

  // Creates a store
  final store = await newSqliteLocalCacheStore(file: file);

  // Creates a cache with a capacity of 10 from the previously created store
  final cache = await store.cache<Task>(
      name: 'cache1',
      fromEncodable: (json) => Task.fromJson(json),
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

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_hive/LICENSE) file for details