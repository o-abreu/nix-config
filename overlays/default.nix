{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
{
  additions = import ./additions.nix;
  unstable-packages = import ./unstable-packages.nix { inherit inputs; };
  firefox-addons = import ./firefox-addons.nix { inherit inputs; };
  wezterm-plugins = import ./wezterm-plugins.nix { inherit inputs lib; };
  neotest-nix = inputs.neotest-nix.overlays.default;
  yazi-plugins = inputs.nix-yazi-plugins.overlays.default;
  modifications = lib.composeManyExtensions [
    (import ./yazi.nix)
    (import ./snacks.nix)
    (import ./vim-plugins.nix { inherit inputs lib; })
    (import ./quarto.nix)
  ];
}
