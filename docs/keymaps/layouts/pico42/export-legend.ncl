let E = import "export-legend-lib.ncl" in
let km =
  (import "../../../../keymaps/pico42/keymap.ncl")
  & (import "keymap-ncl-to-json.ncl")
in
let numbered = km.layers_of_keys in
let named_rows =
  if std.record.has_field "named_layer_names" km then
    km.named_layer_names
    |> std.array.map (fun name =>
      km.layer_as_array_of_keys (std.record.get name km.named_layers)
    )
  else
    []
in
let layer_rows = numbered @ named_rows in
let named_indices =
  if std.record.has_field "named_layer_indices" km then
    km.named_layer_indices
  else
    {}
in
E.bundle_of_with_index "keymaps/pico42/keymap.ncl" layer_rows named_indices
