# INFO: stylix option scopes for nixd (NixOS + Home-Manager, flake-value modules)
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? stylix) {
    attr = ''stylix = builtins.getFlake "${inputs.stylix}";'';
    mod = ''(builtins.getFlake "${inputs.stylix}").nixosModules.stylix'';
  };

  home-manager = lib.optional (inputs ? stylix) {
    attr = ''stylix = builtins.getFlake "${inputs.stylix}";'';
    mod = ''(builtins.getFlake "${inputs.stylix}").homeModules.stylix'';
  };
}