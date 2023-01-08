import 'dart:ffi';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:stash_isar/stash_isar.dart';

Future<IsarVaultStore> newVaultStore() {
  return Directory.systemTemp.createTemp('stash_isar').then((dir) {
    final path = dir.path;
    return Isar.initializeIsarCore(
            libraries: {Abi.current(): '$path/libisar.dylib'}, download: true)
        .then((_) => path);
  }).then((path) => newIsarLocalVaultStore(path: path, inspector: false));
}

Future<IsarCacheStore> newCacheStore() {
  return Directory.systemTemp
      .createTemp('stash_isar')
      .then((d) => newIsarLocalCacheStore(path: d.path, inspector: false));
}
