SMART_KEYMAP ?= $(abspath $(CURDIR)/submodules/smart-keymap)

FIRMWARE_CH32X ?= $(SMART_KEYMAP)/firmware/ch32x035-usb-device-compositekm-c

.PHONY: all
all: firmware-ch32x_48-rgoulter.hex

.PHONY: clean
clean:
	rm -rf $(FIRMWARE_CH32X)/build
	rm -f firmware-ch32x_48-rgoulter.hex

firmware-ch32x_48-rgoulter.hex: KEYMAP := keymaps/ortho-4x12/keymap.ncl
firmware-ch32x_48-rgoulter.hex: BOARD := keyboards/ch32x-48.ncl
firmware-ch32x_48-rgoulter.hex: keymaps/ortho-4x12/keymap.ncl keyboards/ch32x-48.ncl
	@echo Building keymap in $(SMART_KEYMAP)...
	(cd $(SMART_KEYMAP) && devenv shell just keymap=$(abspath $(CURDIR)/$(KEYMAP)) dest_dir=$(FIRMWARE_CH32X)/libsmartkeymap/ install)
	@echo Building firmware in $(FIRMWARE_CH32X)...
	(cd $(FIRMWARE_CH32X) && devenv shell just board=$(abspath $(CURDIR)/$(BOARD)) build)
	@echo Copying firmware artifact...
	cp $(FIRMWARE_CH32X)/build/usb-device-compositekm.hex $@

