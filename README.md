# HeroSet

HeroSet is a gamified Connect IQ watch app for the Garmin Forerunner 965.
The planned daily mission tracks push-ups, sit-ups, squats, and an optional
10 km run. Exercise totals reset when the watch enters a new local calendar
day. The app will support automatic repetition estimates with manual entry and
correction.

## Project configuration

- App type: Watch App
- Target: Forerunner 965 (`fr965`)
- Minimum Connect IQ API: 4.2.0
- Language: Monkey C

## Requirements

- Garmin Connect IQ SDK and Forerunner 965 device support
- Java 11 or newer
- Visual Studio Code with the Monkey C extension, or the Connect IQ command-line
  tools
- A private Connect IQ developer signing key

LazyVim can remain the primary editor. See [`docs/development.md`](docs/development.md)
for setup, build, simulator, and signing-key details.

## Documentation

- [`docs/development.md`](docs/development.md): local setup, build, simulator,
  and signing-key handling
- [`docs/compatibility.md`](docs/compatibility.md): device-support tiers and
  capability-matrix policy
- [`docs/store-release.md`](docs/store-release.md): pricing, monetization, and
  release requirements

## Repository layout

```text
manifest.xml       Application metadata and target products
monkey.jungle      Connect IQ build configuration
source/            Monkey C source files
resources/         Strings, layouts, menus, and drawable assets
bin/               Generated build output; ignored by Git
```
