/// Provides a in-memory implementation of the Stash caching API for Dart
library stash_memory;

import 'package:stash_memory/src/memory/memory_store.dart';

export 'package:stash/stash_api.dart';

export 'src/memory/memory_store.dart';

/// Creates a new [MemoryVaultStore]
MemoryVaultStore newMemoryVaultStore() {
  return MemoryVaultStore();
}

/// Creates a new [MemoryCacheStore]
MemoryCacheStore newMemoryCacheStore() {
  return MemoryCacheStore();
}
