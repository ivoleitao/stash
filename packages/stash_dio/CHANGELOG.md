## 5.0.3

 - **CHORE**: Update a dependency to the latest release.

## 5.0.2

 - **CHORE**: Update a dependency to the latest release.

## 5.0.1

 - **CHORE**: Update a dependency to the latest release.

## 4.6.3

 - **FIX**: Reading nested JSON throws TypeError issue [#45](https://github.com/ivoleitao/stash/issues/45). ([e93ff90e](https://github.com/ivoleitao/stash/commit/e93ff90ed0f849779b58c3baa4d34973608ce7ab))

## 4.6.2

 - **CHORE**: Update a dependency to the latest release.

## 4.6.1

 - **CHORE**: updated dependencies
 
## 4.6.0

 - **FEAT**: added shared_preferences support.
 - **FEAT**: added flutter support.

## 4.5.0

 - **FIX**: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34).
 - **FEAT**: added isar support.

# 4.4.0

- BREAKING CHANGE: Changed minimum sdk version
- chore: Updated dependencies

# 4.3.4

- feat: Updated stash, stash_memory and stash_file dependencies

# 4.3.3

- chore: Updated dependencies

# 4.3.2

- feat: dependency updates
- chore: Improved and added package attributes

# 4.3.1

- chore: version bump

# 4.3.0

- chore: Updated dependencies

# 4.2.0

- chore: Version bump

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
- feat: Adapted the dio API to better handle the creation of interceptors

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 3.2.3

- Corrected formatting
- Updated SDK

# 3.2.2

- Updated dependencies

# 3.2.1

- Fixed the README file

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache interceptors

# 3.1.0

- Updated dependencies
- Switched from `pedantic` to lints

# 3.0.2

- Updated dependencies
- Fixed issue [Multiple cache-control headers are not handled](https://github.com/ivoleitao/stash/issues/14)

# 3.0.1

- Updated dependencies
- Fixed issue [stash_dio crash when reading from named hive cache](https://github.com/ivoleitao/stash/issues/13)

# 3.0.0

- Updated dependencies
- Releasing the lastest development version of 3.x line

# 3.0.0-dev.1

- Updated to the latest dart sdk
- Updated dependencies
- Added support for events

# 2.0.4

- Fixed issue [stash_dio crash when reading from hive cache](https://github.com/ivoleitao/stash/issues/9)
- Merged pull request [Fix cache control value separator](https://github.com/ivoleitao/stash/pull/10)

# 2.0.3

- Updated dependencies
- Fixed issue [stash_dio: Null check operator used on a null value](https://github.com/ivoleitao/stash/issues/8)

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
- Migrated to new interceptor API

# 2.0.0-nullsafety.1

- Null safety support

# 1.0.3

- Updated to the most recent version of stash

# 1.0.2

- Updated dependencies

# 1.0.1

- Wrongly removed the Equatable dependency, now restored

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
