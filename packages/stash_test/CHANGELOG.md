## 4.5.1

- **CHORE**: Updated dependencies
## 4.5.0

 - **FEAT**: added shared_preferences support.
 - **FEAT**: added flutter support.

## 4.4.1

 - **FIX**: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34).

# 4.4.0

- BREAKING CHANGE: Changed minimum sdk version
- chore: Updated dependencies

# 4.3.4

- feat: Updated stash dependency

# 4.3.3

- chore: Updated dependencies

# 4.3.2

- feat: dependency updates
- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies
- chore: Improved and added package attributes

# 4.3.1

- feature: updated dependencies
- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 
- chore: Improved and added package attributes

# 4.3.0

- chore: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- chore: Version bump

# 4.1.0

- BREAKING CHANGE: Changed minimum sdk version
- BREAKING CHANGE: The creation of vaults and caches now returns a `Future<Vault<T>>` and `Future<Cache<T>>`
- chore: Updated dependencies
- feat: Added `removeAll` tests
- feat: Added `remove` tests
- feat: Added `getAll` tests
- feat: Added `putAll` tests
- feat: melos configured with `usePubspecOverrides`

# 4.0.1

- chore: Updated dependencies
- chore: Updated package description
- fix: melos script does not run tests in parallel anymore 
- feat: Added test case to get an inexisting key on both cache and vault

# 4.0.0

- build: Release version
- chore: Fixed the example
- feat: Added Hyperbolic eviction test

# 4.0.0-dev.2

- chore: Changelog fixes and example linking to the main stash package

# 4.0.0-dev.1

- BREAKING CHANGE: First version after major revamp adding support for generics, vaults and statistics

# 3.2.2

- Corrected formatting
- Updated SDK

# 3.2.1

- Updated dependencies

# 3.2.0

- Updated dependencies

# 3.1.0

- Updated dependencies
- Switched from `pedantic` to lints

# 3.0.1

- Updated dependencies

# 3.0.0

- Updated dependencies
- Releasing the lastest development version of 3.x line

# 3.0.0-dev.3

- Updated to the latest dart sdk
- Updated dependencies
- Removed mandatory override
- Integrated event tests
- Added support to launch all tests through a unique call allowing filtering of both type and features tests

# 3.0.0-dev.2

- Removed mandatory override

# 3.0.0-dev.1

- Initial version extracted out of the `stash` package