# stash_sqlite
A [stash](https://github.com/ivoleitao/stash) storage extension for sqlite using the [moor](https://pub.dev/packages/moor) package

[![Pub Package](https://img.shields.io/pub/v/stash_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sqlite)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_sqlite)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash_sqlite-blue.svg)](https://www.dartdocs.org/documentation/stash_sqlite/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a storage layer through the [moor](https://pub.dev/packages/moor) persistent library and relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format. This storage backend is particularly optimized to support `stash` features, like expiration and eviction which are highly dependent on the update of control fields on the cache entries upon user operations. On this storage backend the update of those fields does not cause the update of the whole cache entry as some of the other storage implementations like [stash_hive](https://pub.dartlang.org/packages/stash_hive) or [stash_sembast](https://pub.dartlang.org/packages/stash_sembast) since they are stored in specific columns on the relational database model.

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
import 'package:stash_sqlite/stash_sqlite.dart';
```

## Usage

The example bellow stores a Task object on a sqlite cache that uses a in-memory implementation of the database. A truly persistent alternative is also possible as presented through the use of an alternate moor QueryExecutor. Both alternatives take advantage of the [moor_ffi](https://pub.dev/packages/moor_ffi) package which provides dart bindings for sqlite. Moor itself provides support relational database support on multiple environments ranging from mobile to desktop.

```dart
import 'dart:io';

import 'package:moor_ffi/moor_ffi.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({this.id, this.title, this.completed = false});

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
    return 'Task ${id}: "${title}" is ${completed ? "completed" : "not completed"}';
  }
}

CacheDatabase memoryDatabase() {
  // Create a in-memory database
  return CacheDatabase(VmDatabase.memory());
}

CacheDatabase diskDatabase(File file) {
  // Creates a disk based database
  return CacheDatabase(VmDatabase(file));
}

void main() async {
  // Creates cache with a sqlite based storage backend with a maximum capacity 10 entries
  final cache = newSqliteCache(memoryDatabase(),
      maxEntries: 10, fromEncodable: (json) => Task.fromJson(json));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(id: 1, title: 'Run stash_sqlite example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
```

## Contributing

This library is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a [Github pull request](https://github.com/ivoleitao/stash/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_sqlite/LICENSE) file for details