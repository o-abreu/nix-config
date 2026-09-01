{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  # from: apply { inputs } to fragments that need it (wrapper-style overlays)
  from = path: import path { inherit inputs; };
in
{
  additions = import ./additions.nix;
  unstable-packages = from ./unstable-packages.nix;
  firefox-addons = from ./firefox-addons.nix;
  yazi-plugins = inputs.nix-yazi-plugins.overlays.default;
  modifications = lib.composeManyExtensions [
    (import ./yazi.nix)
    (import ./snacks.nix)
  ];
}
