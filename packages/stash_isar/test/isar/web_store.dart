import 'package:stash_isar/stash_isar.dart';

Future<IsarVaultStore> newVaultStore() {
  return newIsarLocalVaultStore();
}

Future<IsarCacheStore> newCacheStore() {
  return newIsarLocalCacheStore();
}
