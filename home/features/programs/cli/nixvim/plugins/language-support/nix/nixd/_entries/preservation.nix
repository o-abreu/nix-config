# INFO: preservation option scope for nixd (NixOS only, path module)
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? preservation) {
    attr = ''preservation = builtins.getFlake "${inputs.preservation}";'';
    mod = ''(import ${inputs.preservation}/module.nix)'';
  };
}