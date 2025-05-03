# Smart Keymap User Configuration

Repository with user-defined keyboards and keymaps
 for [smart-keymap](https://github.com/rgoulter/smart-keymap)-based firmware.

## Dependencies

[DevEnv](https://devenv.sh/) is used to provide the toolchain dependencies.

Use `devenv shell` to enter a shell which has all the tooling installed.

A [DevContainer](https://containers.dev/) is defined for the project, which can be used to easily get started using [e.g. VSCode, GitHub Codespaces, etc.](https://containers.dev/supporting).

## Keyboard Firmware

### Pico42

[src/bin/pico42.rs](src/bin/pico42.rs) contains the Rust keyboard firmware, implemented using RTIC for the [Pico42 keyboard](https://github.com/rgoulter/keyboard-labs/releases/tag/pico42-rev2023.2).

Its keymap definition uses [keymaps/pico42/keymap.ncl](keymaps/pico42/keymap.ncl).

`pico42.uf2` can be built by running:

```
make pico42.uf2
```

This `.uf2` file can then be flashed onto the RP2040.

For building & flashing directly, you can run:

```
just rp2040-flash pico42
```

### CH32X-48

Firmware for the
[CH32X-48](https://github.com/rgoulter/keyboard-labs/releases/tag/ch32x-48-rev2025.4)
is described by [keyboards/ch32x-48.ncl](keyboards/ch32x-48.ncl) and
[keymaps/ortho-4x12/keymap.ncl](keymaps/ortho-4x12/keymap.ncl).

Its firmware can be built by running:

```
make firmware-ch32x_48-rgoulter.hex
```

This firmware can then be flashed onto the board using [wchisp](https://github.com/ch32-rs/wchisp).

For convenience, a `just` recipe is also provided:

```
just wch-flash firmware-ch32x_48-rgoulter.hex
```
