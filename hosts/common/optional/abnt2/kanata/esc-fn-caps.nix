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

      # caps: tap=esc, hold=Ctrl (left control) + fn layer
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

      # The actual f keys, with no modifier.
      #
      # The hold action above emits `lctl`, which makes every key pressed while
      # caps is held behave as Ctrl+key. That is wanted for everything except
      # the F-row, which must stay bare (`Ctrl+F<n>` is a different binding in
      # most applications, or is swallowed outright).
      #
      # `release-key` drops the already-emitted `lctl` so the F-key goes out
      # unmodified. Every other key is deliberately absent from this layer, so
      # it stays transparent and keeps the Ctrl modifier.
      layers.fn = lib.genAttrs fKeys (key: "(multi (release-key lctl) ${key})");
    };
}
