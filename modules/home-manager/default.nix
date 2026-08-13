{ inputs, ... }:
let
  tree = inputs.import-tree;
in
{
  cheatsheet = tree [ ./cheatsheet ];
  mutability = tree [ ./mutability ];
  ssh-agent = tree [ ./ssh-agent ];
  stylix_presenterm = tree [ ./stylix/presenterm ];
  presenterm = tree [ ./presenterm ];
  wezterm-override = tree [ ./wezterm-override ];
  wfrc = tree [ ./wfrc ];
}
