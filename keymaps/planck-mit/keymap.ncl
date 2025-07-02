# Port of my layout.
#
# Implemented elsewhere, e.g.:
# - https://github.com/rgoulter/qmk_userspace/tree/master/layouts/planck_mit/rgoulter

let BASE_LAYER_COUNT = 2 in
let BASE_DV_HRM_ = 0 in
let BASE_DV_ = 1 in

let LOWER_  = BASE_LAYER_COUNT in
let LOWER2_ = LOWER_ + 1 in
let RAISE_  = LOWER2_ + 1 in
let RAISE2_ = RAISE_ + 1 in
let ADJUST_ = RAISE2_ + 1 in

{
  chords =
    let K = import "keys.ncl" in
    [
      { indices = [26, 27], key = K.LeftGUI & K.PageUp, },
      { indices = [32, 33], key = K.LeftGUI & K.PageDown, },
    ],
  config.tap_hold.interrupt_response = "HoldOnKeyTap",
  config.tap_hold.required_idle_time = 40,
  custom_keys = fun K =>
    let HoldLayerMod = fun layer_index => K.hold (K.layer_mod.hold layer_index) in
    {
      LWR_TAB  = K.Tab & HoldLayerMod LOWER_,
      LW2_ESC  = K.Escape & HoldLayerMod LOWER2_,
      RS2_BSP  = K.Backspace & HoldLayerMod RAISE2_,
      RSE_ENT  = K.Return & HoldLayerMod RAISE_,

      DV_H  = K.layer_mod.set_default BASE_DV_HRM_,
      DV_T  = K.layer_mod.set_default BASE_DV_,

      DV = DV_H & { tap_dances = [DV_T] }

      ADJU = K.layer_mod.hold ADJUST_,

      A_A = K.A & K.H_LAlt,
      G_O = K.O & K.H_LGUI,
      C_E = K.E & K.H_LCtrl,
      S_U = K.U & K.H_LShift,

      S_H = K.H & K.H_RShift,
      C_T = K.T & K.H_LCtrl,
      G_N = K.N & K.H_RGUI,
      A_S = K.S & K.H_LAlt,

      SK_S = K.sticky K.LeftShift,
      SK_C = K.sticky K.LeftCtrl,
      SK_G = K.sticky K.LeftGUI,
      SK_A = K.sticky K.LeftAlt,
    },

  layers = [
    # Base: Dvorak (HRM)
    m%"
      '     ,     .    P        Y        XXXX     XXXX F        G       C    R    L
      A_A   G_O   C_E  S_U      I        XXXX     XXXX D        S_H     C_T  G_N  A_S
      ;     Q     J    K        X        XXXX     XXXX B        M       W    V    Z
      XXXX  XXXX  XXXX LWR_TAB  LW2_ESC      SPC       RS2_BSP  RSE_ENT XXXX XXXX XXXX
    "%,

    # Base: Dvorak
    m%"
      '     ,     .    P        Y        XXXX     XXXX F        G       C    R    L
      A     O     E    U        I        XXXX     XXXX D        H       T    N    S
      ;     Q     J    K        X        XXXX     XXXX B        M       W    V    Z
      XXXX  XXXX  XXXX LWR_TAB  LW2_ESC      SPC       RS2_BSP  RSE_ENT XXXX XXXX XXXX
    "%,

    # Lower
    m%"
       !    @    #    $    %    ~    |    ^    &    *    (    )
       ~    XXXX XXXX XXXX XXXX INS  ?    INS  _    +    {    }
       ?    XXXX XXXX XXXX |    XXXX XXXX XXXX XXXX XXXX ?    |
       TTTT TTTT TTTT XXXX TTTT   TTTT    TTTT ADJU TTTT TTTT TTTT
    "%,

    # Lower2
    m%"
       F12  F7   F8   F9   PSCR XXXX XXXX XXXX XXXX XXXX XXXX XXXX
       F11  F4   F5   F6   SCRL XXXX XXXX LEFT DOWN UP   RGHT XXXX
       F10  F1   F2   F3   PAUS XXXX XXXX HOME PGDN PGUP END  XXXX
       TTTT TTTT TTTT TTTT XXXX   TTTT    TTTT TTTT TTTT TTTT TTTT
    "%,

    # Raise
    m%"
       1    2    3    4    5    XXXX XXXX 6    7    8    9    0
       `    XXXX XXXX XXXX XXXX XXXX XXXX DEL  -    =    [    ]
       /    XXXX XXXX XXXX \    XXXX XXXX XXXX XXXX XXXX /    \
       TTTT TTTT TTTT ADJU TTTT   TTTT    TTTT XXXX TTTT TTTT TTTT
    "%,

    # Raise2
    m%"
       XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
       SK_A SK_G SK_C SK_S XXXX XXXX XXXX XXXX SK_S SK_C SK_G SK_A
       XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
       TTTT TTTT TTTT TTTT TTTT   TTTT    XXXX TTTT TTTT TTTT TTTT
    "%,

    # Adjust
    m%"
       BOOT XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
       CAPS XXXX XXXX XXXX XXXX XXXX XXXX XXXX DV   XXXX XXXX XXXX
       XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
       TTTT TTTT TTTT XXXX TTTT   XXXX    TTTT XXXX TTTT TTTT TTTT
    "%,
  ],
}
