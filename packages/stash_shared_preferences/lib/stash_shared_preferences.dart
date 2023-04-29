/// Provides a Shared Preferences implementation of the Stash API for Dart
library stash_shared_preferences;

import 'package:stash/stash_api.dart';
import 'package:stash_shared_preferences/stash_shared_preferences.dart';

export 'src/shared_preferences_adapter.dart';
export 'src/shared_preferences_store.dart';

/// Creates a [SharedPreferencesVaultStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<SharedPreferencesVaultStore> newSharedPreferencesVaultStore(
    {StoreCodec? codec}) {
  return SharedPreferencesAdapter.build()
      .then((adapter) => SharedPreferencesVaultStore(adapter, codec: codec));
}

/// Creates a [SharedPreferencesCacheStore]
///
/// * [codec]: The [StoreCodec] used to convert to/from a Map<String, dynamic>` representation to a binary representation
Future<SharedPreferencesCacheStore> newSharedPreferencesCacheStore(
    {StoreCodec? codec}) {
  return SharedPreferencesAdapter.build()
      .then((adapter) => SharedPreferencesCacheStore(adapter, codec: codec));
}
