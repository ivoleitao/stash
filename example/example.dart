import 'package:stash/stash_memory.dart';

void main() async {
  // Creates a memory based cache with a a capacity of 10
  final cache = newMemoryCache(maxEntries: 10);

  // Adds a 'value2' under 'key1' to the cache
  await cache.put('key1', 'value2');
  // Retrieves the value from the cache
  final value = await cache.get('key1');

  print(value);
}
