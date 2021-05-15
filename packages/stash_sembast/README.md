# stash_sembast
A [stash](https://github.com/ivoleitao/stash) storage extension for [sembast](https://pub.dev/packages/sembast)

[![Pub Package](https://img.shields.io/pub/v/stash_sembast.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_sembast)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_sembast)](https://codecov.io/gh/ivoleitao/stash_sembast)
[![Package Documentation](https://img.shields.io/badge/doc-stash_sembast-blue.svg)](https://www.dartdocs.org/documentation/stash_sembast/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a 
[sembast](https://pub.dev/packages/sembast) based storage that relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_sembast:

```dart
dependencies:
    stash_sembast: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_sembast/stash_sembast.dart';
```

## Usage

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a 
[hive](https://pub.dev/packages/sembast) based storage that relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format.


```dart
import 'dart:io';

import 'package:stash_sembast/stash_sembast.dart';

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
  // Temporary path
  final dir = Directory.systemTemp;
  // Temporary database file
  final file = File('${dir.path}/stash_sqlite.db');

  // Creates cache with a Sembast based storage backend with the capacity of 10 entries
  final cache = newSembastFileCache(file,
      maxEntries: 10, fromEncodable: (json) => Task.fromJson(json));

  // Adds a task with key 'task1' to the cache
  await cache.put('task1',
      Task(id: 1, title: 'Run stash_sembast example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}

```

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash_sembast/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_sembast/LICENSE) file for details