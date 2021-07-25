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
  final store = newMemoryStore();
  // Creates a cache with a capacity of 10 from the previously created store
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the first cache'));
  // Creates a third cache with a capacity of 10 from the previously created store
  final cache2 = store.cache(
      cacheName: 'cache2',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the second cache'));

  // Adds a task with key 'task1' to the first cache
  await cache1.put('task1',
      Task(id: 1, title: 'Run shared store example (1)', completed: true));
  // Retrieves the value from the first cache
  print(await cache1.get('task1'));

  // Adds a task with key 'task1' to the second cache
  await cache2.put('task1',
      Task(id: 2, title: 'Run shared store example (2)', completed: true));
  // Retrieves the value from the second cache
  print(await cache2.get('task1'));
}
