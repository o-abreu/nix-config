{ inputs, ... }:
let
  tree = inputs.import-tree;
in
{
  cheatsheet = tree [ ./cheatsheet ];
  mutability = tree [ ./mutability ];
  opencode = tree [ ./opencode ];
  presenterm = tree [ ./presenterm ];
  ssh-agent = tree [ ./ssh-agent ];
  stylix_noctalia = tree [ ./stylix/noctalia ];
  stylix_presenterm = tree [ ./stylix/presenterm ];
  wezterm-override = tree [ ./wezterm-override ];
  wfrc = tree [ ./wfrc ];
}
