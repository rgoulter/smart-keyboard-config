dest_dir := "firmware/ch32x035-usb-device-compositekm-c/libsmartkeymap/"

rp2040-flash bin:
    env \
        SMART_KEYMAP_CUSTOM_KEYMAP="$(pwd)/keymaps/pico42/keymap.ncl" \
        cargo run \
            --release \
            --target=thumbv6m-none-eabi \
            --bin={{bin}}

wch-flash file: wch-await-bootloader
  wchisp flash {{file}}

wch-await-bootloader:
  timeout 30 submodules/smart-keymap/firmware/ch32x035-usb-device-compositekm-c/scripts/wchisp-await-bootloader.sh
