import 'dart:io';

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
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary directory
  final path = Directory.systemTemp.path;

  // Creates a store
  final store = newFileLocalVaultStore(
      path: path, fromEncodable: (json) => Task.fromJson(json));

  // Creates a vault from the previously created store
  final vault = store.vault<Task>(
      name: 'vault', eventListenerMode: EventListenerMode.synchronous)
    ..on<VaultEntryCreatedEvent<Task>>().listen(
        (event) => print('Key "${event.entry.key}" added to the vault'));

  // Adds a task with key 'task1' to the vault
  await vault.put(
      'task1', Task(id: 1, title: 'Run vault store example', completed: true));
  // Retrieves the value from the vault
  print(await vault.get('task1'));
}