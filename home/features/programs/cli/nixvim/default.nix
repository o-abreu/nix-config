{ inputs, lib, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];
  
  # INFO: Many plugin authors do not bother to add a LICENSE file to their plugins. When LICENSE is absent, nixpkgs defensively assumes that the software is unfree.
  nixpkgs.config.allowUnfreePredicate = pkg: pkg.name or "" |> lib.hasPrefix "vimplugin-";

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;
      viAlias = true;
    };
  };
}
