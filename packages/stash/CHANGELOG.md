## 5.0.2

 - **CHORE**: Update a dependency to the latest release.

## 5.0.1

 - **CHORE**: Update a dependency to the latest release.

## 5.0.0

- **BREAKING CHANGE**: Changed minimum sdk version
- chore: Updated dependencies


## 4.5.3

 - **FIX**: Reading nested JSON throws TypeError issue [#45](https://github.com/ivoleitao/stash/issues/45). ([e93ff90e](https://github.com/ivoleitao/stash/commit/e93ff90ed0f849779b58c3baa4d34973608ce7ab))

## 4.5.2

 - **FIX**: in the scope of https://github.com/ivoleitao/stash/issues/43 operations on a cache or vault should not imply reading the full entry from the backing store when supported, or if they do the deserialization should not happen as only the info objects needs to be retrieved. This change had a number of consequences namely removing the support for getting the (Cache/Vault)Entry from some events: CacheEntryEvictedEvent, CacheEntryExpiredEvent, (Cache/Vault)RemovedEvent, (Cache/Vault)UpdatedEvent. A fix was also made on sqlite_stash where the getInfo was not working correctly. This is part 1 of the fix, the backing stores should stop obtaining the Entry when asked to obtain the info.

## 4.5.1

- **DOC**: Added platform and sdk information

## 4.5.0

 - **FEAT**: added shared_preferences support.
 - **FEAT**: added flutter support.

## 4.4.1

 - **FIX**: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34).

# 4.4.0

- BREAKING CHANGE: Changed minimum sdk version
- chore: Updated dependencies

# 4.3.4

- fix:Involuntary breaking change, extension methods are now targeting again `Store<VaultInfo, VaultEntry>` and `Store<CacheInfo, CacheEntry>` (see https://github.com/ivoleitao/stash/issues/38)

# 4.3.3

- chore: Updated dependencies
- feat: Added VaultStore and CacheStore marker interfaces to allow a cleaner usage of a store or cache abstraction for more advanced clients
- fix: Improved the documentation

# 4.3.2

- fix: Removed extra coverage link in README
- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies
- chore: Updated dependencies
- chore: Improved and added package attributes

# 4.3.1

- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 

# 4.3.0

- chore: Updated README
- chore: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- feat: Added support for the cbl package

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- chore: Updated dependencies
- feat: Added support for `removeAll`
- feat: Added support for `getAll`
- feat: Added support for `putAll`
- feat: melos configured with `usePubspecOverrides`
- chore: Updated README

# 4.0.1

- chore: Updated dependencies
- fix: Fixed a bug when fetching a non existing key (see https://github.com/ivoleitao/stash/issues/24)

# 4.0.0

- build: Release version

# 4.0.0-dev.2

- chore: Changelog fixes and example linking to the main stash package

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 3.2.3

- Updated SDK
- Updated dependencies

# 3.2.2

- Fixed location of the build action

# 3.2.1

- Updated dependencies

# 3.2.0

- Updated dependencies
- Applied pull request [RandomSampler fix to return correct sample size](https://github.com/ivoleitao/stash/pull/15)

# 3.1.0

- Switched from `pedantic` to lints
- BREAKING CHANGE: Due to new lint rules the EventListenerMode enum now uses camel case constants
- BREAKING CHANGE: Due to new lint rules the EntryEventType enum now uses camel case constants
- Updated dependencies

# 3.0.1

- Updated dependencies

# 3.0.1

- Reverted the async package version to 2.6.1 as 2.7.0 is incompatible with flutter_test as reported in [Stash 3.0.0 is incompatible with flutter_test](https://github.com/ivoleitao/stash/issues/12)

# 3.0.0

- Releasing the lastest development version of 3.x line

# 3.0.0-dev.2

- Updated to the latest dart sdk
- Updated dependencies
- Added support for events
- Some dynamic add ? and the new analyser flags it as a warning, fixed
- BREAKING CHANGE: Msgpack was removed into a separate library, `stash_msgpack`, inside stash.
- BREAKING CHANGE: CacheEntry does not allow to set the value directly anymore a copyForUpdate operation is now needed

# 3.0.0-dev.2

 - First development version of the 3.x.x version
 - BREAKING CHANGE: This version removes the harness and the stash memory storage extension from stash

# 2.0.2

- Fixed additional problems in the documentation

# 2.0.1

- Updated documentation

# 2.0.0

- Removed prerelease github action
- Updated dependencies
- Moved to a mono repo
- Restructured github actions
- Removed derry support and adopted melos

# 2.0.0-nullsafety.4

- Changed the concurrency to 1 of the coverage generation as it was hanging in some ocasions.
- Removed dependency on quiver since it was being used only for the mockable clock and replaced with the clock package
- It now compiles and runs in dartjs, fixes [issue 5](https://github.com/ivoleitao/stash/issues/5)
- Changed the way the DateTime is serialized in MsgPack. It now uses a toIso8601String
- Fixed a number of race conditions in the tests that were dependent on wall clock
- Improved feedback of the test that failed in the test run
- Isolated MsgPack tests that use 64 bit integers as they do not work on dartjs

# 2.0.0-nullsafety.3

- Some smaller fixes
- Updated dependencies
- Updated github actions with setup dart action
- derry support

# 2.0.0-nullsafety.2

- Added prerelease github action

# 2.0.0-nullsafety.1

- Null safety support

# 1.0.4

- Fixed CHANGELOG
# 1.0.3

- Updated dependencies

# 1.0.2

- Republish to tackle problem with pub reverting to sdk 2.9.3

# 1.0.1

- Corrected typo on the README file for the 1.0.0 version of the last published package

# 1.0.0

- First official release of this package
- Updated to 2.10.0 sdk version
- Updated dependencies

# 1.0.0-dev.3

- Updated to 2.9.0 sdk version
- Updated dependencies
- Corrected a analyser error

# 1.0.0-dev.2

- Removed unsecure link from the README file
- Improved README text and corrected some errors on CustomStore example
- Updated dependencies

# 1.0.0-dev.1

- Initial version
