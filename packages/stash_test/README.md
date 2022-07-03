# stash_test
A [stash](https://github.com/ivoleitao/stash) test support package

[![Pub Package](https://img.shields.io/pub/v/stash_test.svg?style=flat-square)](https://pub.dartlang.org/packages/stash_test)
[![Coverage Status](https://codecov.io/gh/ivoleitao/stash/graph/badge.svg?flag=stash_test)](https://codecov.io/gh/ivoleitao/stash_test)
[![Package Documentation](https://img.shields.io/badge/doc-stash_test-blue.svg)](https://www.dartdocs.org/documentation/stash_test/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Provides testing support [stash](https://pub.dartlang.org/packages/stash) storage and cache implementations

## Getting Started

Add this to your `pubspec.yaml` (or create it) on the `dev_dependencies` section replacing x.x.x with the latest version of stash_test: 

```dart
dev_dependencies:
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

The `stash_test` library provides a way to easily import the set of standard tests for [Store](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache_store.dart) and [Cache](https://github.com/ivoleitao/stash/blob/develop/packages/stash/lib/src/api/cache.dart) allowing to reuse them to test custom implementations provided by external parties but also to test the storage and cache implementations provided in the package ecossistem of `stash`. The main objective is to guarantee that all storage implementations perform the full suite of type tests but also the standart `stash` tests.

For example let's consider that a third party developer creates a custom store, `CustomStore`, and wishes to test it against the same set of tests that are used on `stash_file`, `stash_hive` and similar packages. On the `test/custom` folder of the package the following file `custom_store_test.dart` can be created:

```dart
import 'package:stash_custom/stash_custom.dart';
import 'package:stash_test/stash_test.dart';

class DefaultContext extends TestContext<CustomStore> {
  DefaultContext(super.generator);

  @override
  Future<FileStore> newStore() {
    return Future.value(CustomStore(...));
  }
}

void main() async {
  testStore((generator) => DefaultContext(generator));
  testCache((generator) => DefaultContext(generator));
}
```

Notice that in order to leverage the same set of tests a class extending `TextContext` needs to created and used on the calls to the two provided functions:
* `testStore`: which runs all the store tests
* `testCache`: which runs all the cache tests

Please take a look at the examples provided on one of the storage implementations, for example [stash_file](https://github.com/ivoleitao/stash/tree/develop/packages/stash_file) or [stash_sqlite](https://github.com/ivoleitao/stash/tree/develop/packages/stash_sqlite).

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/stash/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/stash/blob/develop/packages/stash_test/LICENSE) file for details