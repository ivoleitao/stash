# stash_test
A [stash](https://github.com/ivoleitao/stash) in-memory storage extension for 

[![Pub Package](https://img.shields.io/pub/v/stash_test.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_test)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_test)](https://codecov.io/gh/ivoleitao/stash_test)
[![Package Documentation](https://img.shields.io/badge/doc-stash_test-blue.svg)](https://www.dartdocs.org/documentation/stash_test/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This storage extension for [stash](https://pub.dartlang.org/packages/stash) provides in-memory based storage.

## Getting Started

Add this to your `pubspec.yaml` (or create it) replacing x.x.x with the latest version of stash_test: 

```dart
dependencies:
    stash_test: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:stash_test/stash_test.dart';
```
## Usage

The `stash_test` library provides a way to easily import the set of standard tests that are used for the reference implementations of [CacheStore](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache_store.dart) and [Cache](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache.dart) allowing to reuse them to test custom implementations provided by external parties. It also provides as number of classes that allow the generation of values which can be used in each one of the tests:
* `BoolGenerator`
* `IntGenerator`
* `DoubleGenerator`
* `StringGenerator`
* `IteratorGenerator`
* `MapGenerator`
* `SampleClassGenerator`


Find bellow an example implementation to test a `CustomStore`

```dart
// Import the stash harness
import 'package:stash/stash_harness.dart';
// Import your custom extension here
import 'package:stash_custom/stash_custom.dart';
// Import the test package
import 'package:test/test.dart';

// Primitive test context, to be used for the primitive tests
class DefaultContext extends TestContext<CustomStore> {
  DefaultContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>) fromEncodable})
      : super(generator, fromEncodable: fromEncodable);


  // Provide a implementation of the function that creates a store, 
  @override
  Future<CustomStore> newStore() {
    ...
  }

  // Optionally provide a implementation of the function that creates a custom cache 
  DefaultCache newCache(T store,
      {String name,
      ExpiryPolicy expiryPolicy,
      KeySampler sampler,
      EvictionPolicy evictionPolicy,
      int maxEntries,
      CacheLoader cacheLoader,
      Clock clock}) {
      ...
  }

  // Plug test `expect` method with the `check`used in the tests
  // This is needed to avoid having `test` package dependencies 
  // on the base `stash` library
  @override
  void check(actual, matcher, {String reason, skip}) {
    expect(actual, matcher, reason: reason, skip: skip);
  }

  // Optionally provide a implementation of the function that deletes a store. 
  Future<void> deleteStore(CustomStore store) {
    ...
  }
}

// Object test context, to be used for the class tests
// This example uses the provided SampleClass
class ObjectContext extends DefaultContext {
  ObjectContext(ValueGenerator generator)
      : super(generator,
            fromEncodable: (Map<String, dynamic> json) =>
                SampleClass.fromJson(json));
}

void main() async {
  ...
  // Test the `int` primitive with the provided `DefaultContext`
  test('Int', () async {
    // Run all the tests for a store
    await testStoreWith<CustomStore>(DefaultContext(IntGenerator()));
    // Run all the test for a cache
    await testCacheWith<CustomStore>(DefaultContext(IntGenerator()));
  });
  ...
  // Test the `SampleClass` with a ìnt` field
  test('Class<int>', () async {
    // Run all the tests for a store
    await testStoreWith<CustomStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
    // Run all the test for a cache
    await testCacheWith<CustomStore>(
        ObjectContext(SampleClassGenerator(IntGenerator())));
  });
  ...
```

Please take a look at the examples provided on one of the storage implementations, for example [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) or [stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite).

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_test/LICENSE) file for details