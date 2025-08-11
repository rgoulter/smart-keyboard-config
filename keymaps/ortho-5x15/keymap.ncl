let remap_60keys = { source_key_count = 60 } & (import "layouts/remap.ncl") in

let from_ortho_5x12 = fun
  {
    no_key = XXX,
    from_layout = [
      k00, k01, k02, k03, k04, k05,                k06, k07, k08, k09, k10, k11,
      k12, k13, k14, k15, k16, k17,                k18, k19, k20, k21, k22, k23,
      k24, k25, k26, k27, k28, k29,                k30, k31, k32, k33, k34, k35,
      k36, k37, k38, k39, k40, k41,                k42, k43, k44, k45, k46, k47,
      k48, k49, k50, k51, k52, k53,                k54, k55, k56, k57, k58, k59,
    ]
  } =>
  [
      k00, k01, k02, k03, k04, k05, XXX, XXX, XXX, k06, k07, k08, k09, k10, k11,
      k12, k13, k14, k15, k16, k17, XXX, XXX, XXX, k18, k19, k20, k21, k22, k23,
      k24, k25, k26, k27, k28, k29, XXX, XXX, XXX, k30, k31, k32, k33, k34, k35,
      k36, k37, k38, k39, k40, k41, XXX, XXX, XXX, k42, k43, k44, k45, k46, k47,
      k48, k49, k50, k51, k52, k53, XXX, XXX, XXX, k54, k55, k56, k57, k58, k59,
  ]
in
(import "../ortho-5x12/keymap.ncl")
  |> remap_60keys.into_layout from_ortho_5x12
