import 'dart:io';

import 'package:stash_sqlite/stash_sqlite.dart';

void main() async {
  // Temporary directory
  final dirPath = Directory.systemTemp;
  // Temporary database file for a shared store
  final file = File('${dirPath.path}/stash_sqlite.sdb');

  // Creates a store
  final store = newSqliteLocalVaultStore(file: file);

  // Creates a preferences from the previously created store
  final preferences = store.preferences(
      name: 'preferences', eventListenerMode: EventListenerMode.synchronous)
    ..on<VaultEntryCreatedEvent>().listen((event) => print(
        'Key "${event.entry.key}" with value "${event.entry.value}" added to preferences'));

  // Adds a int value to the preferences
  await preferences.setInt('int', 10);
  // Retrieves the value from the preferences
  print(await preferences.getInt('int'));

  // Adds a string value to the preferences
  await preferences.setString('string', 'ten');
  // Retrieves the value from the preferences
  print(await preferences.getString('string'));
}
