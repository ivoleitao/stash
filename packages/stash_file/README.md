# stash_file
A [stash](https://pub.dartlang.org/packages/stash) file storage extension

[![Pub Package](https://img.shields.io/pub/v/stash_file.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_file)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_file)](https://codecov.io/gh/ivoleitao/stash)
[![Package Documentation](https://img.shields.io/badge/doc-stash_file-blue.svg)](https://www.dartdocs.org/documentation/stash_file/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a file based storage that relies on a highly performing binary serialization of the cache items through the use of [msgpack](https://msgpack.org) serialization format. This storage backend is particularly optimized to support `stash` features, like expiration and eviction, which are highly dependent on the update of control fields on the cache entries upon user operations. The main advantage is that the update of the control fields does not cause the update of the whole cache entry as some of the other storage implementations like [stash_hive](https://pub.dartlang.org/packages/stash_hive) or [stash_sembast](https://pub.dartlang.org/packages/stash_sembast). It relies on a file system abstraction provided by the  [file](https://pub.dartlang.org/packages/file) package

## Getting Started

Add this to your `pubspec.yaml` (or create it):

```dart
dependencies:
    stash_file: ^2.0.0
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_file/stash_file.dart';
```

## Usage

The example bellow creates a cache with a file storage backend that supports a maximum of 10 `Task` objects. In the rather simple example bellow the serialization and deserialization of the object is coded by hand but normally it relies on the usage of libraries like [json_serializable](https://pub.dev/packages/json_serializable). Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information and to explore the full range of capabilities of the `stash` library

```dart
  import 'package:stash_file/stash_file.dart';

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

  void main() async {
  // Creates a cache on the local storage with a maximum capacity of 10 entries
  final cache = newLocalDiskCache(
      maxEntries: 10, fromEncodable: (json) => Task.fromJson(json));

    // Adds a task with key 'task1' to the cache
    await cache.put(
        'task1', Task(id: 1, title: 'Run stash_file example', completed: true));
    // Retrieves the value from the cache
    final value = await cache.get('task1');

    print(value);
  }
```
## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_file/LICENSE) file for details