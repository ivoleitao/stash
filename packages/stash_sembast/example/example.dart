import 'dart:io';

import 'package:stash_sembast/stash_sembast.dart';

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

  // Creates cache with a Sembast based storage backend with the capacity of 10 entries
  final cache = newSembastCache(path,
      maxEntries: 10, fromEncodable: (json) => Task.fromJson(json));

  // Adds a task with key 'task1' to the cache
  await cache.put('task1',
      Task(id: 1, title: 'Run stash_sembast example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
