# INFO: hydenix option scopes for nixd
# NOTE: only the NixOS module is included. The home-manager module needs an
# `inputs` argument whose `comma.nix` imports another flake's module inside
# `imports`, which triggers infinite recursion in a static declaration eval.
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? hydenix) {
    attr = ''hydenix = builtins.getFlake "${inputs.hydenix}";'';
    mod = ''(import ${inputs.hydenix}/hydenix/modules/system)'';
  };
}