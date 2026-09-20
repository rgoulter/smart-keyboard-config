SMART_KEYMAP ?= $(abspath $(CURDIR)/submodules/smart-keymap)

FIRMWARE_CH32X ?= $(SMART_KEYMAP)/firmware/ch32x035-usb-device-compositekm-c
FIRMWARE_CH58X ?= $(SMART_KEYMAP)/firmware/ch58x-ble-hid-keyboard-c

BUILD_DIR := .build

# Track the smart-keymap submodule commit so firmware rebuilds after
# `git submodule update` (or a commit/checkout inside the submodule).
#
# Uncommitted edits inside the submodule are *not* tracked by this stamp —
# after local smart-keymap development, force a rebuild with `make -B <target>`
# or `just rebuild <name>`.
#
# Depending on the submodule directory itself is a bad idea: directory mtimes
# move for unrelated reasons (cd, git status, editor junk). A rev stamp is the
# stable "did the dependency pin move?" signal for a config repo.
SMART_KEYMAP_GIT_HEAD := $(wildcard $(CURDIR)/.git/modules/submodules/smart-keymap/HEAD)
SMART_KEYMAP_REV := $(BUILD_DIR)/smart-keymap.rev

$(SMART_KEYMAP_REV): $(SMART_KEYMAP)/.git $(SMART_KEYMAP_GIT_HEAD)
	@mkdir -p $(dir $@)
	@git -C $(SMART_KEYMAP) rev-parse HEAD > $@.tmp
	@if ! cmp -s $@ $@.tmp 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

# ── CH32X (WCH USB composite) ────────────────────────────────────────
# $(call ch32x_firmware,artifact-stem,keymap.ncl,board.ncl)
#
# smart-keymap's firmware justfile derives a per-board/keymap build dir and hex name
#  (build-<board_id>-<keymap_id>/usb-device-compositekm-<board_id>-<keymap_id>.hex).
# board_id is the board file stem for boards outside ncl/boards/
#  (our keyboards/ are passed as absolute paths, so e.g. ch32x-60-improved).
# keymap_id is the parent dir name for keymap.ncl/keymap.json
#  (e.g. keymaps/ansi-66-extend/keymap.ncl -> ansi-66-extend).
# BOARD_ID/KEYMAP_ID mirror that derivation with make builtins,
#  so the cp below finds the hex without shell string surgery.
# The keymap must also reach the firmware build via SMART_KEYMAP_CUSTOM_KEYMAP
#  (it selects the build dir/hex),
#  not just the install step.
define ch32x_firmware
firmware-$(1).hex: KEYMAP := $(2)
firmware-$(1).hex: BOARD := $(3)
firmware-$(1).hex: BOARD_ID := $(basename $(notdir $(3)))
firmware-$(1).hex: KEYMAP_ID := $(if $(filter keymap.ncl keymap.json,$(notdir $(2))),$(notdir $(patsubst %/,%,$(dir $(2)))),$(basename $(notdir $(2))))
firmware-$(1).hex: $(2) $(3) $(SMART_KEYMAP_REV)
	@echo Building keymap in $$(SMART_KEYMAP)...
	(cd $$(SMART_KEYMAP) && devenv shell just keymap=$$(abspath $$(CURDIR)/$$(KEYMAP)) dest_dir=$$(FIRMWARE_CH32X)/libsmartkeymap/ install)
	@echo Building firmware in $$(FIRMWARE_CH32X)...
	(cd $$(FIRMWARE_CH32X) && \
		SMART_KEYMAP_CUSTOM_KEYMAP=$$(abspath $$(CURDIR)/$$(KEYMAP)) \
		devenv shell just --set board $$(abspath $$(CURDIR)/$$(BOARD)) build)
	@echo Copying firmware artifact...
	cp $$(FIRMWARE_CH32X)/build-$$(BOARD_ID)-$$(KEYMAP_ID)/usb-device-compositekm-$$(BOARD_ID)-$$(KEYMAP_ID).hex $$@

HEX_ARTIFACTS += firmware-$(1).hex
endef

# ── CH58X (WCH BLE HID) ──────────────────────────────────────────────
# $(call ch58x_firmware,artifact-stem,keymap.ncl,board.ncl)
# Same per-board/keymap arrangement as CH32X, with HID_Keyboard-*.hex names.
define ch58x_firmware
firmware-$(1).hex: KEYMAP := $(2)
firmware-$(1).hex: BOARD := $(3)
firmware-$(1).hex: BOARD_ID := $(basename $(notdir $(3)))
firmware-$(1).hex: KEYMAP_ID := $(if $(filter keymap.ncl keymap.json,$(notdir $(2))),$(notdir $(patsubst %/,%,$(dir $(2)))),$(basename $(notdir $(2))))
firmware-$(1).hex: $(2) $(3) $(SMART_KEYMAP_REV)
	@echo Building keymap in $$(SMART_KEYMAP)...
	(cd $$(SMART_KEYMAP) && devenv shell just keymap=$$(abspath $$(CURDIR)/$$(KEYMAP)) dest_dir=$$(FIRMWARE_CH58X)/libsmartkeymap/ install)
	@echo Building firmware in $$(FIRMWARE_CH58X)...
	(cd $$(FIRMWARE_CH58X) && \
		SMART_KEYMAP_CUSTOM_KEYMAP=$$(abspath $$(CURDIR)/$$(KEYMAP)) \
		devenv shell just --set board $$(abspath $$(CURDIR)/$$(BOARD)) build)
	@echo Copying firmware artifact...
	cp $$(FIRMWARE_CH58X)/build-$$(BOARD_ID)-$$(KEYMAP_ID)/HID_Keyboard-$$(BOARD_ID)-$$(KEYMAP_ID).hex $$@

HEX_ARTIFACTS += firmware-$(1).hex
endef

# Catalog: name → keymap + board
$(eval $(call ch32x_firmware,ch32x_36_lhs-rgoulter,keymaps/split_3x5+3/keymap.ncl,keyboards/ch32x-36-lhs.ncl))
$(eval $(call ch32x_firmware,ch32x_36_lhs-miryoku-rgoulter,keymaps/split_3x5+3-miryoku/keymap.ncl,keyboards/ch32x-36-lhs.ncl))
$(eval $(call ch32x_firmware,ch32x_48-rgoulter,keymaps/ortho-4x12/keymap.ncl,keyboards/ch32x-48.ncl))
$(eval $(call ch32x_firmware,ch32x_48-rev2025_2-rgoulter,keymaps/ortho-4x12/keymap.ncl,keyboards/ch32x-48/rev2025_2.ncl))
$(eval $(call ch32x_firmware,ch32x_48-basic-rgoulter,keymaps/ortho-4x12-basic/keymap.ncl,keyboards/ch32x-48.ncl))
$(eval $(call ch32x_firmware,ch32x_75-rgoulter,keymaps/ortho-5x15/keymap.ncl,keyboards/ch32x-75.ncl))
$(eval $(call ch32x_firmware,ch32x_60_improved-extend,keymaps/ansi-66-extend/keymap.ncl,keyboards/ch32x-60-improved.ncl))
$(eval $(call ch58x_firmware,wabble-60-rgoulter,keymaps/ortho-5x12/keymap.ncl,keyboards/wabble-60.ncl))

# Additional Nickel imports of catalog keymaps.
firmware-ch32x_48-rgoulter.hex \
firmware-ch32x_48-rev2025_2-rgoulter.hex: \
	keymaps/split_3x5+3/keymap.ncl

firmware-ch32x_75-rgoulter.hex: \
	keymaps/ortho-5x12/keymap.ncl

# ── RP2040 (Pico42) ──────────────────────────────────────────────────
# cargo tracks .rs graph itself once invoked; SMART_KEYMAP_REV forces a cargo
# run after submodule pin moves (so make does not skip a stale ELF).

target/thumbv6m-none-eabi/release/pico42: \
		src/bin/pico42.rs \
		keymaps/pico42/keymap.ncl \
		keymaps/split_3x5+3/keymap.ncl \
		Cargo.toml \
		$(SMART_KEYMAP_REV)
	env \
		SMART_KEYMAP_CUSTOM_KEYMAP="$(abspath $(CURDIR)/keymaps/pico42/keymap.ncl)" \
		cargo build \
			--release \
			--target=thumbv6m-none-eabi \
			--bin=pico42

pico42.uf2: target/thumbv6m-none-eabi/release/pico42
	picotool uf2 convert target/thumbv6m-none-eabi/release/pico42 -t elf pico42.uf2

UF2_ARTIFACTS := pico42.uf2
ALL_ARTIFACTS := $(HEX_ARTIFACTS) $(UF2_ARTIFACTS)

# ── aggregates ───────────────────────────────────────────────────────

.PHONY: all
all: $(ALL_ARTIFACTS)

.PHONY: clean
clean:
	rm -rf $(FIRMWARE_CH32X)/build $(FIRMWARE_CH32X)/build-*
	rm -rf $(FIRMWARE_CH58X)/build $(FIRMWARE_CH58X)/build-*
	rm -f $(FIRMWARE_CH32X)/libsmartkeymap/libsmart_keymap.a
	rm -f $(FIRMWARE_CH32X)/libsmartkeymap/smart_keymap.h
	rm -f $(FIRMWARE_CH58X)/libsmartkeymap/libsmart_keymap.a
	rm -f $(FIRMWARE_CH58X)/libsmartkeymap/smart_keymap.h
	rm -rf $(BUILD_DIR)
	rm -rf target
	rm -f $(ALL_ARTIFACTS)

# Also wipe smart-keymap cargo outputs (slow; use when keymap lib looks stuck).
.PHONY: clean-cargo
clean-cargo: clean
	$(MAKE) -C $(SMART_KEYMAP) clean

# List catalog names (used by just choosers). One name per line, no prefix/suffix.
.PHONY: list-firmwares
list-firmwares:
	@printf '%s\n' \
		ch32x_36_lhs-rgoulter \
		ch32x_36_lhs-miryoku-rgoulter \
		ch32x_48-rgoulter \
		ch32x_48-rev2025_2-rgoulter \
		ch32x_48-basic-rgoulter \
		ch32x_75-rgoulter \
		ch32x_60_improved-extend \
		wabble-60-rgoulter \
		pico42
