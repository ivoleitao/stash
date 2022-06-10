# 4.2.0

- chore: Version bump

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- BREAKING CHANGE: The creation of stores now returns a `Future<XXXStore>` where XXX is the specific store
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

# 3.2.0

- Updated dependencies
- It's now easier to reuse a store in multiple cache instances
- BREAKING CHANGE: `path` is now an optional parameter in `newObjectBoxCache`

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

# 1.0.0

- Initial version