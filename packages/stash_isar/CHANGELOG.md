# 4.3.2

- feat: dependency updates
- chore: Made the flutter dependencies standout to avoid overrides when updating dependencies

# 4.3.1

- fix: downgraded some dependencies to guarantee compatibility with latest flutter version (see https://github.com/ivoleitao/stash/issues/34) 
- feat: updated dependencies

# 4.3.0

- feat: Updated dependencies
- BREAKING CHANGE: The `fromEncodable` function is not specified on the store creation but instead on the `vault` or `cache` creation. This allows vaults and caches that support different classes with different `fromEncodable` functions

# 4.2.0

- feat: Initial version
