# 3.0.0-dev.1

- Updated to the latest dart sdk
- Updated dependencies
- Added support for events
- Some dynamic add ? and the new analyser flags it as a warning, fixed
- BREAKING: This version removes the harness and the stash memory storage extension from stash 
- BREAKING: Msgpack was removed into a separate library, `stash_msgpack`, inside stash.
- BREAKING: CacheEntry does not allow to set the value directly anymore a copyForUpdate operation is now needed

## 2.0.2

- Fixed additional problems in the documentation

## 2.0.1

- Updated documentation

## 2.0.0

- Removed prerelease github action
- Updated dependencies
- Moved to a mono repo
- Restructured github actions
- Removed derry support and adopted melos

## 2.0.0-nullsafety.4

- Changed the concurrency to 1 of the coverage generation as it was hanging in some ocasions.
- Removed dependency on quiver since it was being used only for the mockable clock and replaced with the clock package
- It now compiles and runs in dartjs, fixes [issue 5](https://github.com/ivoleitao/stash/issues/5)
- Changed the way the DateTime is serialized in MsgPack. It now uses a toIso8601String
- Fixed a number of race conditions in the tests that were dependent on wall clock
- Improved feedback of the test that failed in the test run
- Isolated MsgPack tests that use 64 bit integers as they do not work on dartjs

## 2.0.0-nullsafety.3

- Some smaller fixes
- Updated dependencies
- Updated github actions with setup dart action
- derry support

## 2.0.0-nullsafety.2

- Added prerelease github action

## 2.0.0-nullsafety.1

- Null safety support

## 1.0.4

- Fixed CHANGELOG
## 1.0.3

- Updated dependencies

## 1.0.2

- Republish to tackle problem with pub reverting to sdk 2.9.3

## 1.0.1

- Corrected typo on the README file for the 1.0.0 version of the last published package

## 1.0.0

- First official release of this package
- Updated to 2.10.0 sdk version
- Updated dependencies

## 1.0.0-dev.3

- Updated to 2.9.0 sdk version
- Updated dependencies
- Corrected a analyser error

## 1.0.0-dev.2

- Removed unsecure link from the README file
- Improved README text and corrected some errors on CustomStore example
- Updated dependencies

## 1.0.0-dev.1

- Initial version
