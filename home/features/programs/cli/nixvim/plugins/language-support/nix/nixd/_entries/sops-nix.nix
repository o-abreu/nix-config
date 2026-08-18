# INFO: sops-nix option scopes for nixd (NixOS + Home-Manager, path modules)
{ inputs, lib, ... }:
{
  nixos = lib.optional (inputs ? sops-nix) {
    attr = ''sops-nix = builtins.getFlake "${inputs.sops-nix}";'';
    mod = ''(import ${inputs.sops-nix}/modules/sops)'';
  };

  home-manager = lib.optional (inputs ? sops-nix) {
    attr = ''sops-nix = ${inputs.sops-nix};'';
    mod = ''(import ${inputs.sops-nix}/modules/home-manager/sops.nix)'';
  };
}