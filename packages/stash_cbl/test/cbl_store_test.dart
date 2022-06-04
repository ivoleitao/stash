import 'dart:io';

import 'package:cbl_dart/cbl_dart.dart';
import 'package:stash_cbl/stash_cbl.dart';
import 'package:stash_test/stash_test.dart';

final _cblInitialization = CouchbaseLiteDart.init(edition: Edition.community);

class VaultStoreContext extends VaultTestContext<CblVaultStore> {
  VaultStoreContext(super.generator)
      : async = true,
        super(fromEncodable: generator.fromEncodable);

  VaultStoreContext.sync(super.generator)
      : async = false,
        super(fromEncodable: generator.fromEncodable);

  final bool async;

  @override
  Future<CblVaultStore> newStore() async {
    await _cblInitialization;
    return Directory.systemTemp
        .createTemp('stash_cbl')
        .then((d) => newCblLocalVaultStore(
              path: d.path,
              fromEncodable: fromEncodable,
              async: async,
            ));
  }
}

class CacheStoreContext extends CacheTestContext<CblCacheStore> {
  CacheStoreContext(super.generator)
      : async = true,
        super(fromEncodable: generator.fromEncodable);

  CacheStoreContext.sync(super.generator)
      : async = false,
        super(fromEncodable: generator.fromEncodable);

  final bool async;

  @override
  Future<CblCacheStore> newStore() async {
    await _cblInitialization;
    return Directory.systemTemp
        .createTemp('stash_cbl')
        .then((d) => newCblLocalCacheStore(
              path: d.path,
              fromEncodable: fromEncodable,
              async: async,
            ));
  }
}

void main() async {
  testStore(VaultStoreContext.new);
  testStore(CacheStoreContext.new);
  testVault(VaultStoreContext.new);
  testCache(CacheStoreContext.new);
  testStore(VaultStoreContext.sync);
  testStore(CacheStoreContext.sync);
  testVault(VaultStoreContext.sync);
  testCache(CacheStoreContext.sync);
}
