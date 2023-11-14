# Contributing

## Getting Started

Install the dependencies:

Make sure Rust and pnpm are installed.

```sh
pnpm i
```

## Updating

(more info on [tauri](https://tauri.app/v1/guides/development/updating-dependencies)'s page)

To update deps, run:

```sh
pnpm update @tauri-apps/cli @tauri-apps/api --latest
```

To check for cargo updates, you can run:

```sh
cargo outdated
```

## Running

To run the app, run:

```sh
pnpm tauri dev
```

## Debugging

tauri has a good guide on [debugging](https://tauri.app/v1/guides/debugging/application).

Apparently you can even [programatically open devtools](https://tauri.app/v1/guides/debugging/application#opening-devtools-programmatically), which seems cool.

## Building

To build the app, run:

```sh
pnpm tauri build --debug
```

The debug switch allows for users to open up the devtools panel, which will be useful for debugging since the app is still in development. We also have devtools enabled in `Cargo.toml`, so the devtools should be available in production builds.

## Test Standards

<!-- TODO (subsections on rust and js/ts, info on playwright and vitest/jest whichever i decide to use, etc.) -->