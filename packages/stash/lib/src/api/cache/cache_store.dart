import '../store.dart';
import 'cache_entry.dart';
import 'cache_info.dart';

// Cache store marker interface
abstract class CacheStore extends Store<CacheInfo, CacheEntry> {}
