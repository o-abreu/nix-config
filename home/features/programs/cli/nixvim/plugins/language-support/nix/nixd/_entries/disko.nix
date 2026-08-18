# INFO: disko option scope for nixd (NixOS only, path module)
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? disko) {
    attr = ''disko = builtins.getFlake "${inputs.disko}";'';
    mod = ''(import ${inputs.disko}/module.nix)'';
  };
}