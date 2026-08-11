# Smart Keymap User Configuration

Repository with user-defined keyboards and keymaps
 for [smart-keymap](https://github.com/rgoulter/smart-keymap)-based firmware.

## Dependencies

[DevEnv](https://devenv.sh/) is used to provide the toolchain dependencies.

Use `devenv shell` to enter a shell which has all the tooling installed.

A [DevContainer](https://containers.dev/) is defined for the project, which can be used to easily get started using [e.g. VSCode, GitHub Codespaces, etc.](https://containers.dev/supporting).

## Building firmware

[Make](Makefile) is the build engine (dependency graph + artifacts).
[just](justfile) is the day-to-day chooser / flash helper.

```
just                  # list recipes
just list             # list firmware catalog names
just build-pick       # fzf: pick a firmware to build
just flash-pick       # fzf: pick a firmware to build + flash
just build ch32x_48-rgoulter
just flash pico42
make all              # build every artifact
```

Firmware artifacts depend on:

- the local keymap / board `.ncl` (and `src/bin/*.rs` for RP2040), and
- the **smart-keymap submodule commit** (via `.build/smart-keymap.rev`)

So a `git submodule update` correctly invalidates builds. Uncommitted edits
inside the submodule are not tracked — force with `just rebuild <name>` or
`make -B <artifact>` after developing smart-keymap in-tree.

### Pico42

[src/bin/pico42.rs](src/bin/pico42.rs) contains the Rust keyboard firmware, implemented using RTIC for the [Pico42 keyboard](https://github.com/rgoulter/keyboard-labs/releases/tag/pico42-rev2023.2).

Its keymap definition uses [keymaps/pico42/keymap.ncl](keymaps/pico42/keymap.ncl).

```
just build pico42     # → pico42.uf2
just flash pico42     # cargo run / probe
# or:
make pico42.uf2
```

### CH32X-48

Firmware for the
[CH32X-48](https://github.com/rgoulter/keyboard-labs/releases/tag/ch32x-48-rev2025.4)
is described by [keyboards/ch32x-48.ncl](keyboards/ch32x-48.ncl) and
[keymaps/ortho-4x12/keymap.ncl](keymaps/ortho-4x12/keymap.ncl).

```
just build ch32x_48-rgoulter
just flash ch32x_48-rgoulter   # awaits WCH bootloader, then wchisp
# or:
make firmware-ch32x_48-rgoulter.hex
just wch-flash firmware-ch32x_48-rgoulter.hex
```
