fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run tests on multiple devices

### ios SlatherLane

```sh
[bundle exec] fastlane ios SlatherLane
```

Generate test coverage using Slather

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

A - Generate new localized screenshots

### ios framescreens

```sh
[bundle exec] fastlane ios framescreens
```

B - Frame localized screenshots

### ios UploadScreens

```sh
[bundle exec] fastlane ios UploadScreens
```

C - Upload localized + framed screenshots

### ios allscreens

```sh
[bundle exec] fastlane ios allscreens
```

* - Generate, Frame and Upload

### ios upmeta

```sh
[bundle exec] fastlane ios upmeta
```

Upload localized meta data

### ios upbuild

```sh
[bundle exec] fastlane ios upbuild
```

Upload beta

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
