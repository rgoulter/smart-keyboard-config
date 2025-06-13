# Board codegen contracts.
# (e.g. as defined in rp2040-rtic-smart-keyboard/ncl)
let C = import "codegen/contracts.ncl" in
{
  gpio_pins | { _ | C.GpioPin },

  variant = {
    keymap_index_for_key,
    matrix.key_count,
    usb,
  },

  board | C.Board = {
    usb = variant.usb,

    matrix =
      let p = gpio_pins in
      {
        cols = [
          p.GP0,
          p.GP1,
          p.GP2,
          p.GP3,
          p.GP4,
          p.GP5,
          p.GP6,
          p.GP7,
          p.GP8,
          p.GP9,
          p.GP10,
          p.GP11,
        ],
        rows = [
          p.GP14,
          p.GP15,
          p.GP16,
          p.GP17,
        ],
        key_count = variant.matrix.key_count,
      },

    # Declare, but don't define;
    # this varies for Pico42, PyKey40 Lite, PyKey40 HSRGB.
    keymap_index_for_key = variant.keymap_index_for_key,
  },
}
