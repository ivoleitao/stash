# 4.3.2

- feat: dependency updates
- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies

# 4.3.1

- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 

# 4.3.0

- feat: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- chore: Version bump

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of stores now returns a `Future<XXXStore>` where XXX is the specific store
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- feat: Updated dependencies
- feat: melos configured with `usePubspecOverrides`
- fix: Concurrency problem on the creation / removal of stores

# 4.0.1

- feat: Updated dependencies
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
- Removed dart:io dependencies
- Added support for web

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache instances
- BREAKING CHANGE: `path` is now an optional parameter in `newHiveCache`
- BREAKING CHANGE: `path` is now an optional parameter in `newLazyHiveCache`

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
- Separated lazy and non lazy cache initialization

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

- Updated dependencies

# 1.0.0

- First official release of the package
- Updated to 2.10.0 sdk version
- Updated dependencies

# 1.0.0-dev.4

- Updated to 2.9.0 sdk version
- Updated dependencies

# 1.0.0-dev.3

- Updated sdk to a supported version on pub

# 1.0.0-dev.2

- Removed unsecure link from the README file
- Updated dependencies

# 1.0.0-dev.1

- Initial version
