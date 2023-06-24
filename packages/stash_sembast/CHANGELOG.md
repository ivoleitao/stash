## 5.0.0

- **BREAKING CHANGE**: Changed minimum sdk version
- chore: Updated dependencies

## 4.5.3

 - **FIX**: Reading nested JSON throws TypeError issue [#45](https://github.com/ivoleitao/stash/issues/45). ([e93ff90e](https://github.com/ivoleitao/stash/commit/e93ff90ed0f849779b58c3baa4d34973608ce7ab))

## 4.5.2

 - **FIX**: https://github.com/ivoleitao/stash/issues/43 for getInfo calls objectbox backed storage no longer deserializes the whole entry.
 - **FIX**: https://github.com/ivoleitao/stash/issues/43 for getInfo calls sembast backed storage no longer deserializes the whole entry.
 - **FIX**: in the scope of https://github.com/ivoleitao/stash/issues/43 operations on a cache or vault should not imply reading the full entry from the backing store when supported, or if they do the deserialization should not happen as only the info objects needs to be retrieved. This change had a number of consequences namely removing the support for getting the (Cache/Vault)Entry from some events: CacheEntryEvictedEvent, CacheEntryExpiredEvent, (Cache/Vault)RemovedEvent, (Cache/Vault)UpdatedEvent. A fix was also made on sqlite_stash where the getInfo was not working correctly. This is part 1 of the fix, the backing stores should stop obtaining the Entry when asked to obtain the info.

## 4.5.1

 - **CHORE**: updated dependencies

## 4.5.0

 - **FEAT**: added shared_preferences support.
 - **FEAT**: added flutter support.

## 4.4.1

 - **FIX**: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34).

# 4.4.0

- BREAKING CHANGE: Changed minimum sdk version
- chore: Updated dependencies

# 4.3.4

- feat: Updated stash and stash_test dependencies

# 4.3.3

- chore: Updated dependencies
- feat: Added VaultStore and CacheStore marker interfaces support to allow a cleaner usage of a store or cache abstraction for more advanced clients

# 4.3.2

- feat: dependency updates
- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies
- chore: Improved and added package attributes

# 4.3.1

- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 

# 4.3.0

- chore: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- chore: Version bump

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- BREAKING CHANGE: The creation of stores now returns a `Future<XXXStore>` where XXX is the specific store
- chore: Updated dependencies
- feat: melos configured with `usePubspecOverrides`
- fix: Concurrency problem on the creation / removal of stores

# 4.0.1

- chore: Updated dependencies
- chore: Updated package description

# 4.0.0

- build: Release version

# 4.0.0-dev.2

- chore: Changelog fixes and example linking to the main stash package

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 3.3.1

- Updated SDK

# 3.3.0

- Updated dependencies
- Removed io and web dependencies
- BREAKING CHANGE: The API now receives a path instead of a File this eliminating the dart:io dependency

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache instances
- BREAKING CHANGE: `file` is now an optional parameter in `newSembastFileCache`

# 3.1.0

- Updated dependencies
- Switched from `pedantic` to lints

# 3.0.1

- Updated dependencies

# 3.0.0

- Updated dependencies
- Releasing the lastest development version of 3.x line

# 3.0.0-dev.2

- Updated to the latest dart sdk
- Updated dependencies
- Added support for events

# 3.0.0-dev.1

- Integrated with the new version of stash which implies importing the testing harness from the new stash_test package

# 2.0.3

- Updated dependencies
- Decouple the storage via a new adapter improving the configurability and extensibility
- Added new in-memory database support
- Added new web database support

# 2.0.2

- Updated dependencies

# 2.0.1

- Updated documentation
- Updated dependencies

# 2.0.0

- Removed prerelease github action
- Updated dependencies
- Moved to a mono repo
- Restructured github actions
- Removed derry support and adopted melos

# 2.0.0-nullsafety.2

- Some smaller fixes
- Updated dependencies
- Updated github actions with setup dart action
- derry support

# 2.0.0-nullsafety.1

- Null safety support

# 1.0.2

- Updated to the most recent version of stash

# 1.0.1

- Updated depenencies

# 1.0.0

- First official release of this package
- Updated to 2.10.0 sdk version
- Updated dependencies

# 1.0.0-dev.3

- Updated to 2.9.0 sdk version
- Updated dependencies

# 1.0.0-dev.2

- Removed unsecure link from the README file
- Updated dependencies

# 1.0.0-dev.1

- Initial version
