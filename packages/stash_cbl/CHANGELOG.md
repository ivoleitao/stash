## 5.1.0

 - **CHORE**: Updated dependencies
 - **FEAT**: Added support to close stores and stashes

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

## 4.6.3

 - **FIX**: Reading nested JSON throws TypeError issue [#45](https://github.com/ivoleitao/stash/issues/45). ([e93ff90e](https://github.com/ivoleitao/stash/commit/e93ff90ed0f849779b58c3baa4d34973608ce7ab))

## 4.6.2

 - **FIX**: https://github.com/ivoleitao/stash/issues/43 for getInfo calls cbl backed storage no longer deserializes the whole entry.
 - **FIX**: in the scope of https://github.com/ivoleitao/stash/issues/43 operations on a cache or vault should not imply reading the full entry from the backing store when supported, or if they do the deserialization should not happen as only the info objects needs to be retrieved. This change had a number of consequences namely removing the support for getting the (Cache/Vault)Entry from some events: CacheEntryEvictedEvent, CacheEntryExpiredEvent, (Cache/Vault)RemovedEvent, (Cache/Vault)UpdatedEvent. A fix was also made on sqlite_stash where the getInfo was not working correctly. This is part 1 of the fix, the backing stores should stop obtaining the Entry when asked to obtain the info.

## 4.6.1

 - **CHORE**: updated dependencies
 
## 4.6.0

 - **FEAT**: added shared_preferences support.
 - **FEAT**: added flutter support.

## 4.5.0

 - **FIX**: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34).
 - **FEAT**: add package for Couchbase Lite store.

# 4.4.0

- BREAKING CHANGE: Changed minimum sdk version
- chore: Updated dependencies

# 4.3.4

- feat: Updated stash and stash_test dependencies

# 4.3.3

- chore: Updated dependencies
- feat: Added VaultStore and CacheStore marker interfaces support to allow a cleaner usage of a store or cache abstraction for more advanced clients

# 4.3.2

- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies
- feat: dependency updates
- chore: Improved and added package attributes

# 4.3.1

- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 

# 4.3.0

- chore: Updated dependencies

# 4.2.0

Initial release.
