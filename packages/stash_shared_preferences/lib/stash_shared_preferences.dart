/// Provides a Shared Preferences implementation of the Stash API for Dart
library stash_shared_preferences;

import 'package:stash_shared_preferences/stash_shared_preferences.dart';

export 'src/shared_preferences_adapter.dart';
export 'src/shared_preferences_store.dart';

/// Creates a [SharedPreferencesVaultStore]
Future<SharedPreferencesVaultStore> newSharedPreferencesVaultStore() {
  return SharedPreferencesAdapter.build()
      .then((adapter) => SharedPreferencesVaultStore(adapter));
}

/// Creates a [SharedPreferencesCacheStore]
Future<SharedPreferencesCacheStore> newSharedPreferencesCacheStore() {
  return SharedPreferencesAdapter.build()
      .then((adapter) => SharedPreferencesCacheStore(adapter));
}
