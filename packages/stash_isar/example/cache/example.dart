import 'dart:ffi';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_isar/stash_isar.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  /// Creates a [Task] from json ma
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
  // Initialize Isar
  await Isar.initializeIsarCore(
      libraries: {Abi.current(): '.dart_tool/libisar.dylib'}, download: true);

  // Temporary directory
  final path = Directory.systemTemp.path;

  // Creates a store
  final store = await newIsarLocalCacheStore(path: path);

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
  // Closes the cache
  cache.close();
}
