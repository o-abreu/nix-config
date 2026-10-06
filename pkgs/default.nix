{
  pkgs ? import <nixpkgs> { },
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
}
