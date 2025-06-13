(import "./base.ncl") &
{
  variant = {
    usb = {
      vid = 0xCAFE,
      pid = 0x0005,
      manufacturer = "rgoulter keyboard-labs",
      product = "PyKey40 Lite",
    },

    matrix = {
      key_count = 47, # 4 rows x 12 columns, 1x2U in middle
    },

    keymap_index_for_key = fun { column_index, row_index } =>
      let NO = null in
      let keymap_indices = [
        [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11],
        [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
        [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35],
        [36, 37, 38, 39, 40, 41, NO, 42, 43, 44, 45, 46],
      ]
      in
      let row = std.array.at row_index keymap_indices in
      std.array.at column_index row
      |> match {
        idx if idx != null => 'Key idx,
        _ => 'NoKey,
      },
  }
}
