{ inputs, ... }:
let
  tree = inputs.import-tree;
in
{
  cheatsheet = tree [ ./cheatsheet ];
  mutability = import ./mutability.nix;
  stylix_presenterm = import ./stylix/presenterm;
  presenterm = tree [ ./presenterm ];
  wezterm-override = tree [ ./wezterm-override ];
  wfrc = tree [ ./wfrc ];
}
