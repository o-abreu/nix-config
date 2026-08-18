# INFO: Explicit list of nixd option-scope entries.
# Comment out any line to disable that input's option completion.
# This file and ./_entries are _-prefixed so import-tree never auto-imports them.
{
  inputs,
  lib,
}:
[
  (import ./_entries/disko.nix { inherit inputs lib; })
  (import ./_entries/preservation.nix { inherit inputs lib; })
  (import ./_entries/sops-nix.nix { inherit inputs lib; })
  (import ./_entries/hydenix.nix { inherit inputs lib; })
  (import ./_entries/nix-index-database.nix { inherit inputs lib; })
  (import ./_entries/stylix.nix { inherit inputs lib; })
  (import ./_entries/nixvim.nix { inherit inputs lib; })
]