# INFO: nix-index-database option scopes for nixd (NixOS + Home-Manager, path modules)
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? nix-index-database) {
    attr = ''nix-index-database = builtins.getFlake "${inputs.nix-index-database}";'';
    mod = ''(import ${inputs.nix-index-database}/nixos-module.nix)'';
  };

  home-manager = lib.optional (inputs ? nix-index-database) {
    attr = ''nix-index-database = builtins.getFlake "${inputs.nix-index-database}";'';
    mod = ''(import ${inputs.nix-index-database}/home-manager-module.nix)'';
  };
}