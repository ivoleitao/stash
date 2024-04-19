## 5.1.1

 - **CHORE**: Updated dependencies

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

## 4.5.3

 - Update a dependency to the latest release.

## 4.5.2

 - Update a dependency to the latest release.

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
- chore: Improved and added package attributes

# 4.3.1

- chore: version bump

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

# 3.2.2

- Updated SDK

# 3.2.1

- Updated dependencies

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache instances

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
- Integrated with the new version of stash which implies importing the testing harness from the new stash_test package
- Added support for events

# 3.0.0-dev.1

- Initial version extracted out of the `stash` package

# 1.0.0

- Initial version