import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_shared_preferences/stash_shared_preferences.dart';

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

  /// Creates a json map
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
  const SharedPreferencesDemo({super.key});

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
