{
  pkgs ? import <nixpkgs> { },
  inputs,
  ...
}:
with pkgs;
{
  screenshot = callPackage ./screenshot { };
  presenter = callPackage ./presenter { };
  # INFO: Consumed by `neotest-java`, see the package's own header comment.
  junit-platform-console-standalone = callPackage ./junit-platform-console-standalone { };
  wezterm-floating = callPackage ./wezterm-floating { };
  wfrc = callPackage ./wfrc { };
  # INFO: `asta` CLI from github:allenai/asta-plugins, built via uv2nix so the
  # plugin's `asta-cli` skill finds it on PATH and skips its `uv tool install`.
  asta = callPackage ./asta { inherit inputs; };
}
