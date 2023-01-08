import 'package:stash_isar/stash_isar.dart';

Future<IsarVaultStore> newVaultStore() {
  return newIsarLocalVaultStore(inspector: false);
}

Future<IsarCacheStore> newCacheStore() {
  return newIsarLocalCacheStore(inspector: false);
}
