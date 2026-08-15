# Smart Keyboard Config — day-to-day DX surface.
#
# Make is the build engine (dependency graph + artifacts).
# just is the chooser / flash helper.
#
#   just                  # list recipes
#   just --choose         # fzf over recipes
#   just build-pick       # fzf over firmwares → build (remembers last pick)
#   just flash-pick       # fzf over firmwares → build + flash
#   just build ch32x_48-rgoulter
#   just flash pico42

# ── meta ─────────────────────────────────────────────────────────────

# List recipes (default)
[group('meta')]
default:
    @just --list --unsorted

# Interactive recipe chooser (fzf / JUST_CHOOSER)
[group('meta')]
choose:
    @just --choose

# ── build ────────────────────────────────────────────────────────────

# Build every firmware artifact (make all)
[group('build')]
all:
    make all

# Build one firmware by catalog name
# (e.g. just build ch32x_48-rgoulter | just build pico42)
[group('build')]
build name:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ name }}" in
      pico42) make pico42.uf2 ;;
      *)      make "firmware-{{ name }}.hex" ;;
    esac

# Force-rebuild one firmware (after uncommitted smart-keymap edits)
[group('build')]
rebuild name:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ name }}" in
      pico42) make -B pico42.uf2 ;;
      *)      make -B "firmware-{{ name }}.hex" ;;
    esac

# Interactive: pick a firmware to build (remembers last pick)
[group('build')]
build-pick:
    #!/usr/bin/env bash
    set -euo pipefail
    name="$(just pick-firmware 'Build firmware › ')"
    just build "$name"

# ── flash ────────────────────────────────────────────────────────────

# Build then flash one firmware by catalog name
[group('flash')]
flash name: (build name)
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ name }}" in
      pico42)
        just rp2040-flash pico42
        ;;
      ch32x*|wabble-*)
        just wch-flash "firmware-{{ name }}.hex"
        ;;
      *)
        echo "error: unknown how to flash '{{ name }}'" >&2
        exit 1
        ;;
    esac

# Interactive: pick a firmware to build + flash (remembers last pick)
[group('flash')]
flash-pick:
    #!/usr/bin/env bash
    set -euo pipefail
    name="$(just pick-firmware 'Flash firmware › ')"
    just flash "$name"

# fzf a catalog name; last pick (`.build/last-firmware`) is listed first.
[private]
pick-firmware prompt:
    #!/usr/bin/env bash
    set -euo pipefail
    cache=.build/last-firmware
    last=""
    if [[ -f "$cache" ]]; then
      IFS= read -r last < "$cache" || true
    fi
    names="$(make -s list-firmwares)"
    name="$(
      printf '%s\n' "$names" \
      | awk -v last="$last" '
          $0 == last { seen = 1; next }
          { rest = rest $0 ORS }
          END {
            if (seen) print last
            printf "%s", rest
          }
        ' \
      | fzf --prompt='{{ prompt }}' --height=40% --reverse
    )"
    mkdir -p .build
    printf '%s\n' "$name" > "$cache"
    printf '%s\n' "$name"

# Flash an already-built WCH .hex (awaits bootloader first)
[group('flash')]
wch-flash file: wch-await-bootloader
    wchisp flash {{ file }}

[group('flash')]
wch-await-bootloader:
    timeout 30 submodules/smart-keymap/firmware/ch32x035-usb-device-compositekm-c/scripts/wchisp-await-bootloader.sh

# Build+run pico42 via cargo (RP2040 bootloader / probe)
[group('flash')]
rp2040-flash bin:
    env \
        SMART_KEYMAP_CUSTOM_KEYMAP="$(pwd)/keymaps/pico42/keymap.ncl" \
        cargo run \
            --release \
            --target=thumbv6m-none-eabi \
            --bin={{ bin }}

# ── housekeeping ─────────────────────────────────────────────────────

# Remove firmware artifacts and intermediate builds
[group('build')]
clean:
    make clean

# Print the firmware catalog (same names as build/flash take)
[group('meta')]
list:
    @make -s list-firmwares
