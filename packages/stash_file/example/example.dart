import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_file/stash_file.dart';

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
  final path = Directory.systemTemp.path;

  // Creates a cache on the local storage with the capacity of 10 entries
  final cache = newLocalFileCache(path,
      maxEntries: 10,
      eventListenerMode: EventListenerMode.Sync,
      fromEncodable: (json) => Task.fromJson(json))
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Entry key "${event.entry.key}" added to the cache'));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(id: 1, title: 'Run stash_file example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
