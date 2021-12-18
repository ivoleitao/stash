import 'package:stash_sembast_web/stash_sembast_web.dart';

void main() async {
  // Creates a store
  final store = newSembastWebVaultStore();

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
