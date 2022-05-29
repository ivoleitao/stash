/// Provides a in-memory implementation of the Stash caching API for Dart
library stash_memory;

import 'package:stash_memory/src/memory/memory_store.dart';

export 'src/memory/memory_store.dart';

/// Creates a new [MemoryVaultStore]
Future<MemoryVaultStore> newMemoryVaultStore() {
  return Future.value(MemoryVaultStore());
}

/// Creates a new [MemoryCacheStore]
Future<MemoryCacheStore> newMemoryCacheStore() {
  return Future.value(MemoryCacheStore());
}
