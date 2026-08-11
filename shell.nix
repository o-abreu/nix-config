{
  pkgs ? import <nixpkgs> {},
  experimentalFeatures ? [
    "nix-command"
    "flakes"
    "pipe-operators"
  ],
}: {
  default = with pkgs; pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = ${lib.concatStringsSep " " experimentalFeatures}";
    nativeBuildInputs = [
      nix
      home-manager
      git

      eza
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
