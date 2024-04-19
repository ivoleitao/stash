## 5.2.2

 - **FIX**: Deployment dependency error on stash_test

## 5.2.1

 - **CHORE**: Updated dependencies

## 5.2.0

 - **CHORE**: Updated dependencies
 - **FEAT**: Added support to close stores and stashes

## 5.1.0

 - **FEAT**(sqlite): use NativeDatabase.createInBackground factory. ([2921a92a](https://github.com/ivoleitao/stash/commit/2921a92ac41869e5e4b69c9b2ac16ec6c9d7b637))

## 5.0.3

 - **CHORE**: Updated min dart SDK to 3.2.0
 - **CHORE**: Updated dependencies to the latest release.
 - **CHORE**: Updated melos script

## 5.0.2

 - **CHORE**: Update a dependency to the latest release.

## 5.0.1

 - **CHORE**: Update a dependency to the latest release.

## 5.0.0

- **BREAKING CHANGE**: Changed minimum sdk version
- chore: Updated dependencies

## 4.6.2

 - **FIX**: Reading nested JSON throws TypeError issue [#45](https://github.com/ivoleitao/stash/issues/45). ([e93ff90e](https://github.com/ivoleitao/stash/commit/e93ff90ed0f849779b58c3baa4d34973608ce7ab))

## 4.6.1

 - **FIX**: in the scope of https://github.com/ivoleitao/stash/issues/43 operations on a cache or vault should not imply reading the full entry from the backing store when supported, or if they do the deserialization should not happen as only the info objects needs to be retrieved. This change had a number of consequences namely removing the support for getting the (Cache/Vault)Entry from some events: CacheEntryEvictedEvent, CacheEntryExpiredEvent, (Cache/Vault)RemovedEvent, (Cache/Vault)UpdatedEvent. A fix was also made on sqlite_stash where the getInfo was not working correctly. This is part 1 of the fix, the backing stores should stop obtaining the Entry when asked to obtain the info.

## 4.6.0

 - **FEAT**: added support for flutter_secure_storage as a storage backend.

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
- chore: Improved and added package attributes

# 4.3.1

- chore: version bump

# 4.3.0

- chore: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- chore: Updated dependencies

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- BREAKING CHANGE: The creation of stores now returns a `Future<XXXStore>` where XXX is the specific store
- feat: melos configured with `usePubspecOverrides`
- chore: Updated dependencies

# 4.0.1

- chore: Updated dependencies
- chore: Updated package description

# 4.0.0

- build: Release version

# 4.0.0-dev.2

- chore: Changelog fixes and example linking to the main stash package

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 3.2.2

- Updated SDK

# 3.2.1

- Updated dependencies

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache instances
- BREAKING CHANGE: `file` is now an optional parameter in `newSqliteFileCache`

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

# 2.0.0-nullsafety.1

- Null safety support

# 1.0.4

- Updated dependencies

# 1.0.3

- Updated to the most recent version of stash

# 1.0.2

- Updated dependencies

# 1.0.1

- Fixed a typo in the published README

# 1.0.0

- First official release of this package
- Updated to 2.9.0 sdk version
- Updated dependencies

# 1.0.0-dev.3

- Updated to 2.9.0 sdk version
- Updated dependencies
- Removed dependency on moor_ffi
- Ignored runtime singleton errors

# 1.0.0-dev.2

- Removed unsecure link from the README file
- Updated dependencies

# 1.0.0-dev.1

- Initial version
