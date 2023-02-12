# stash_secure_storage
A [stash](https://github.com/ivoleitao/stash) storage extension for [secure_storage](https://pub.dev/packages/secure_storage)

[![Pub Package](https://img.shields.io/pub/v/stash_secure_storage.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_secure_storage)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_secure_storage)](https://codecov.io/gh/ivoleitao/stash_secure_storage)
[![Package Documentation](https://img.shields.io/badge/doc-stash_secure_storage-blue.svg)](https://www.dartdocs.org/documentation/stash_secure_storage/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides a [secure_storage](https://pub.dev/packages/flutter_secure_storage) based storage.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_secure_storage:

```dart
dependencies:
    stash_secure_storage: ^x.x.x
```

Run the following command to install dependencies:

```dart
flutter pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash/stash_api.dart';
import 'package:stash_secure_storage/stash_secure_storage.dart';
```

## Usage

The example bellow creates a vault with a secure_storage storage backend. In this rather simple example the serialization and deserialization of the object is coded by hand but it's more usual to rely on libraries like [json_serializable](https://pub.dev/packages/json_serializable). 

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_secure_storage/stash_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class Counter {
  final int value;
  final DateTime updateTime;

  Counter({required this.value, required this.updateTime});

  /// Creates a [Counter] from json map
  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
      value: json['value'] as int,
      updateTime: DateTime.parse(json['timestamp'] as String));

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        'timestamp': updateTime.toIso8601String()
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stash Shared Preferences Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({Key? key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<Vault<Counter>> _vault = newSharedPreferencesVaultStore().then(
      (store) => store.vault<Counter>(
          name: 'vault', fromEncodable: (json) => Counter.fromJson(json)));
  late Future<Counter> _counter;

  Future<Counter> _getCounter([Vault<Counter>? vault]) {
    final v = vault == null ? _vault : Future.value(vault);

    return v.then((vault) => vault.get('counter')).then(
        (counter) => counter ?? Counter(value: 0, updateTime: DateTime.now()));
  }

  Future<void> _incrementCounter() async {
    final Vault<Counter> vault = await _vault;
    final Counter currentCounter = await _getCounter(vault);

    setState(() {
      final newCounter =
          Counter(value: currentCounter.value + 1, updateTime: DateTime.now());
      _counter = vault.put('counter', newCounter).then((value) => newCounter);
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _getCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
      ),
      body: Center(
          child: FutureBuilder<Counter>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<Counter> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final count = snapshot.data?.value ?? 0;
                      final updateTime = snapshot.data?.updateTime;
                      final lastPressed = updateTime != null
                          ? ' (last pressed on ${DateFormat('dd-MM-yyyy HH:mm:ss').format(updateTime)})'
                          : '';
                      return Text(
                        'Button tapped $count time${count == 1 ? '' : 's'}.\n\n'
                        'This should persist across restarts$lastPressed.',
                      );
                    }
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Additional Features

Please take a look at the documentation of [stash](https://pub.dartlang.org/packages/stash) to gather additional information and to explore the full range of capabilities of the `stash` library

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_secure_storage/LICENSE) file for details