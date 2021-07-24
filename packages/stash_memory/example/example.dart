import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task(this.id, this.title, {this.completed = false});

  @override
  String toString() {
    return 'Task $id, "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Creates a memory based cache with a capacity of 10
  final cache = newMemoryCache(
      maxEntries: 10, eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>()
        .listen((event) => print('Key "${event.entry.key}" added to cache'));

  // Adds task with key 'task1' to the cache
  await cache.put('task1',
      Task(1, 'Run stash_memory embedded store example', completed: true));
  // Retrieves the value from the cache
  print(await cache.get('task1'));

  // Creates a store
  final store = newMemoryStore();
  // Creates cache1 from the previously created store with a capacity of 10
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>()
        .listen((event) => print('Key "${event.entry.key}" added to cache1'));
  // Creates cache2 from the previously created store with a capacity of 10
  final cache2 = store.cache(
      cacheName: 'cache2',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>()
        .listen((event) => print('Key "${event.entry.key}" added to cache2'));

  // Adds a task with key 'task1' to cache1
  await cache1.put('task1',
      Task(2, 'Run stash_memory shared store example 1', completed: true));
  // Retrieves the value from cache1
  print(await cache1.get('task1'));

  // Adds a task with key 'task1' to cache2
  await cache2.put('task1',
      Task(3, 'Run stash_memory shared store example 2', completed: true));
  // Retrieves the value from cache2
  print(await cache2.get('task1'));
}
