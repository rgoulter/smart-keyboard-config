dest_dir := "firmware/ch32x035-usb-device-compositekm-c/libsmartkeymap/"

wch-flash file: wch-await-bootloader
  wchisp flash {{file}}

wch-await-bootloader:
  timeout 30 submodules/smart-keymap/firmware/ch32x035-usb-device-compositekm-c/scripts/wchisp-await-bootloader.sh
