{inputs, ...}: let
  tree = inputs.import-tree;
in {
  # virtualization = import ./virtualization.nix;
  avahi = import ./avahi.nix;
  mirror-toggle = tree [./mirror-toggle];
  openfortivpn = tree [./openfortivpn];
  touchpad-utils = tree [./touchpad-utils];
  keyboard-utils = tree [./keyboard-utils];
}
