import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

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
  final cache = newMemoryCache(
      maxEntries: 10, eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Entry key "${event.entry.key}" added to the cache'));

  // Adds a task with key 'task1' to the cache
  await cache.put(
      'task1', Task(1, 'Run stash_memory example', completed: true));
  // Retrieves the value from the cache
  final value = await cache.get('task1');

  print(value);
}
