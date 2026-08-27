{ lib, ... }: {
  programs.kanata =
    let
      fKeys = lib.range 1 12 |> map (n: "f${toString n}");
    in
    {
      sourceKeys = [
        "esc"
        "caps"
      ]
      ++ fKeys;

      # Keys lacking a kanata name map to their linux keycodes:
      # KEY_KBDILLUMTOGGLE=228
      # KEY_DISPLAYTOGGLE=431 (0x1af)
      # KEY_TOUCHPAD_TOGGLE=530 (0x212)
      localKeys = {
        kbtoggle = 228;
        displaytoggle = 431;
        touchpadtoggle = 530;
      };

      # caps: tap=esc, hold=Ctrl + fn layer
      aliases.esctrl = "(tap-hold $tt $ht esc (multi lctl (layer-while-held fn)))";

      layers.base = {
        esc = "caps";
        caps = "@esctrl";
        # Base: bare top row -> media/hardware keys (no Fn required)
        f1 = "sleep";
        f2 = "brdown";
        f3 = "brup";
        f4 = "displaytoggle";
        f5 = "touchpadtoggle";
        f6 = "mute";
        f7 = "voldwn";
        f8 = "volu";
        f9 = "kbtoggle";
        # f10 through f12 kept as is.
      };

      # The actual f keys.
      layers.fn = lib.genAttrs fKeys (key: key);
    };
}
