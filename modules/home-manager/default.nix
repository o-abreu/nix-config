{ inputs, ... }:
let
  tree = inputs.import-tree;
in
{
  cheatsheet = tree [ ./cheatsheet ];
  librewolf-extensions = tree [ ./librewolf-extensions ];
  mutability = tree [ ./mutability ];
  opencode = tree [ ./opencode ];
  presenterm = tree [ ./presenterm ];
  ssh-agent = tree [ ./ssh-agent ];
  stylix = tree [ ./stylix ];
  wezterm-override = tree [ ./wezterm-override ];
  wfrc = tree [ ./wfrc ];
  zotero = tree [ ./zotero ];
}
