# ANSI 66-key 60% with a 13-key bottom row (rgoulter layout)
#  (1.25u×4 + 1u×5 + 1.25u×4, GH60-ish / ch32x-60-improved).
#
# Bottom row: LCTL LGUI LALT, then 6 thumbs, then RALT RGUI APPN RCTL.
# The 6 thumbs (taps): TAB ESC SPC BSPC ENT DEL.
# The two innermost (SPC, BSPC) home the thumbs.
#
# Bases: QWERTY plain (default, no HRM), Dvorak with HRM.
# Tap-hold thumbs (60-key rgoulter style): ESC hold lower, ENT hold raise.
# Adjust is a conditional layer (lower + raise).
#
# Chords (positional, same physical keys on both bases):
#  C+V (QWERTY) / J+K (Dvorak) = desk left,
#  M+, (QWERTY) / M+W (Dvorak) = desk right,
#  Z+X (QWERTY) / ;+Q (Dvorak) = sequence start (leader P = desk lock).

let K = import "keys.ncl" in

let os = {
  windows = "windows",
  linux = "linux", # gnome
  macos = "macos",
}
in
let all_os = [os.windows, os.linux, os.macos] in
let DESK_LEFT =
  K.semantic {
    linux = K.LeftGUI & K.PageUp, # Gnome
    macos = K.LeftCtrl & K.Left,
    windows = K.LeftCtrl & K.LeftGUI & K.Left,
  }
in
let DESK_RIGHT =
  K.semantic {
    linux = K.LeftGUI & K.PageDown, # Gnome
    macos = K.LeftCtrl & K.Right,
    windows = K.LeftCtrl & K.LeftGUI & K.Right,
  }
in
let DESK_LOCK =
  K.semantic {
    linux = K.LeftGUI & K.L, # Gnome
    macos = K.LeftCtrl & K.LeftGUI & K.Q,
    windows = K.LeftGUI & K.L,
  }
in

let HoldLayerMod =
  let K = import "keys.ncl" in
  fun layer_name => K.hold (K.layer_mod.hold layer_name) in
{
  chords =
    let K = import "keys.ncl" in
    let CH = import "chording.ncl" in
    [
      {
        indices = m%"
      _ _ _ _ _ _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _ _ _ _ _ _
            _ _ _ X X _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _
    "% |> CH.indices,
        key = DESK_LEFT,
      },
      {
        indices = m%"
      _ _ _ _ _ _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _ _ _ _ _ _
            _ _ _ _ _ _ _ X X _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _
    "% |> CH.indices,
        key = DESK_RIGHT,
      },
      {
        indices = m%"
      _ _ _ _ _ _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _ _ _ _ _ _
            _ X X _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _
    "% |> CH.indices,
        key = K.sequence_start,
      },
    ],
  sequences =
    let K = import "keys.ncl" in
    let CH = import "chording.ncl" in
    [
      {
        indices = m%"
      _ _ _ _ _ _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _ _ X _ _ _
          _ _ _ _ _ _ _ _ _ _ _ _ _
            _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _
    "% |> CH.indices,
        key = DESK_LOCK,
      },
    ],
  config.chorded.required_idle_time = 125,
  config.sequence.timeout = 2500,
  config.tap_hold.interrupt_response = "HoldOnKeyTap",
  config.tap_hold.quick_tap_ms = 300,
  config.tap_hold.required_idle_time = 15,

  # lower = 2, raise = 3, adjust = 4 (after the two numbered base layers).
  named_layer_order = ["lower", "raise", "adjust"],
  conditional_layers = [
    { then_layer = 4, if_layers = [2, 3] },
  ],

  custom_keys = fun K =>
    {
      ESC_L = K.Escape & HoldLayerMod "lower",
      SPC_N = K.Space & HoldLayerMod "nav",
      ENT_R = K.Return & HoldLayerMod "raise",

      QWER = K.layer_mod.set_default 0,
      DVOR = K.layer_mod.set_default 1,

      # Dvorak HRM
      A_A = K.A & K.H_LAlt,
      G_O = K.O & K.H_LGUI,
      C_E = K.E & K.H_LCtrl,
      S_U = K.U & K.H_LShift,

      S_H = K.H & K.H_RShift,
      C_T = K.T & K.H_LCtrl,
      G_N = K.N & K.H_RGUI,
      A_S = K.S & K.H_LAlt,

      # Sticky modifiers
      SK_S = K.sticky K.LeftShift,
      SK_C = K.sticky K.LeftCtrl,
      SK_G = K.sticky K.LeftGUI,
      SK_A = K.sticky K.LeftAlt,

      # Semantic keys: OS
      OS_W = K.layer_mod.set_semantic_variant_to all_os os.windows,
      OS_L = K.layer_mod.set_semantic_variant_to all_os os.linux,
      OS_M = K.layer_mod.set_semantic_variant_to all_os os.macos,
    },

  layers = [
    # Base 0 (default): QWERTY, no HRM
    m%"
      `     1     2     3     4     5     6     7     8     9     0     -     =     BSPC
        TAB   Q     W     E     R     T     Y     U     I     O     P     [     ]     \
          CAPS  A     S     D     F     G     H     J     K     L     ;     '     ENT
            LSFT  Z     X     C     V     B     N     M     ,     .     /     RSFT
      LCTL  LGUI  LALT  TAB   ESC_L SPC_N BSPC  ENT_R DEL   RALT  RGUI  APPN  RCTL
    "%,
    # Base 1: Dvorak with HRM
    m%"
      `     1     2     3     4     5     6     7     8     9     0     [     ]     BSPC
        TAB   '     ,     .     P     Y     F     G     C     R     L     /     =     \
          CAPS A_A   G_O   C_E   S_U   I     D     S_H   C_T   G_N   A_S   -     ENT
            LSFT  ;     Q     J     K     X     B     M     W     V     Z     RSFT
      LCTL  LGUI  LALT  TAB   ESC_L SPC_N BSPC  ENT_R DEL   RALT  RGUI  APPN  RCTL
    "%,
  ],

  named_layers = {
    lower = m%"
      ESC  F1   F2   F3   F4   F5   F6   F7   F8   F9   F10  F11  F12     DEL
        ~    !    @    #    $    %    ^    &    *    (    )    _    +   TTTT
          INS  TTTT TTTT TTTT TTTT TTTT TTTT  _    +    {    }    ?    TTTT
            TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT
      TTTT TTTT TTTT TTTT XXXX TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT
    "%,
    nav = m%"
      ESC  F1   F2   F3   F4   F5   F6   F7   F8   F9   F10  F11  F12     DEL
        `    1    2    3    4    5    6    7    8    9    0    -    =   TTTT
          TTTT TTTT TTTT TTTT TTTT TTTT LEFT DOWN UP   RGHT TTTT TTTT  TTTT
            TTTT TTTT TTTT TTTT TTTT TTTT HOME PGDN PGUP END  TTTT TTTT
      TTTT TTTT TTTT TTTT TTTT XXXX TTTT TTTT TTTT TTTT TTTT TTTT TTTT
    "%,
    raise = m%"
      ESC  F1   F2   F3   F4   F5   F6   F7   F8   F9   F10  F11  F12     DEL
        `    1    2    3    4    5    6    7    8    9    0    -    =   TTTT
          DEL  TTTT TTTT TTTT TTTT TTTT TTTT  -    =    [    ]    /    TTTT
            TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT
      TTTT TTTT TTTT TTTT TTTT TTTT TTTT XXXX TTTT TTTT TTTT TTTT TTTT
    "%,
    adjust = m%"
      QWER DVOR TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT TTTT
        TTTT BOOT TTTT TTTT TTTT TTTT TTTT PSCR SCRL PAUS TTTT TTTT TTTT TTTT
          CWTG SK_A SK_G SK_C SK_S TTTT TTTT SK_S SK_C SK_G SK_A TTTT TTTT
            TTTT TTTT OS_W OS_M OS_L TTTT TTTT MUTE VOLD VOLU MPLY TTTT 
      TTTT TTTT TTTT TTTT XXXX TTTT TTTT XXXX TTTT TTTT TTTT TTTT TTTT
    "%,
  },
}
