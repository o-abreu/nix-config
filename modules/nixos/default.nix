{ inputs, ... }:
let
  tree = inputs.import-tree;
in
{
  # virtualization = import ./virtualization.nix;
  adjust-kbd-backlight = tree [ ./adjust-kbd-backlight ];
  avahi = import ./avahi.nix;
  kanata = tree [ ./kanata ];
  mirror-toggle = tree [ ./mirror-toggle ];
  openfortivpn = tree [ ./openfortivpn ];
  touchpad-toggle = tree [ ./touchpad-toggle ];
}
