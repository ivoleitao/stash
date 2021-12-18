import 'dart:io';

import 'package:stash_sembast/stash_sembast.dart';

void main() async {
  // Temporary path
  final dir = Directory.systemTemp;
  // Temporary database file for a shared store
  final path = '${dir.path}/stash_sembast.sdb';

  // Creates a store
  final store = newSembastLocalVaultStore(path: path);

  // Creates a preferences from the previously created store
  final preferences = store.preferences(
      name: 'preferences', eventListenerMode: EventListenerMode.synchronous)
    ..on<VaultEntryCreatedEvent>().listen((event) => print(
        'Key "${event.entry.key}" with value "${event.entry.value}" added to preferences'));

  // Adds a int value to the preferences
  await preferences.setInt('int', 10);
  // Retrieves the value from the preferences
  print(await preferences.get('int'));

  // Adds a string value to the preferences
  await preferences.setString('string', 'ten');
  // Retrieves the value from the preferences
  print(await preferences.get('string'));
}
