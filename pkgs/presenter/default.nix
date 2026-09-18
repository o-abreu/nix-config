# INFO: `presenter` -- run presenterm in a dedicated, fullscreen WezTerm window.
# See `presenter.sh` for why that is worth a wrapper at all.
{
  pkgs,
  lib,
  # INFO: An argument rather than a hardcoded `pkgs.presenterm`, so callers can
  # substitute a wrapped build. `home/features/programs/cli/presenterm.nix`
  # passes `config.programs.presenterm.finalPackage`, so this launcher runs the
  # presenterm carrying the Home-Manager configuration (theme, PDF export and
  # its runtime deps) instead of a bare nixpkgs build.
  presenterm ? pkgs.presenterm,
  ...
}:
with lib;
let
  name = "presenter";
in
pkgs.writeShellApplication {
  name = name;
  # coreutils/wezterm/presenterm drive the launch; hyprland + jq are needed to
  # find and fullscreen the new window (see presenter.sh).
  runtimeInputs = [
    pkgs.coreutils
    pkgs.hyprland
    pkgs.jq
    pkgs.wezterm
    presenterm
  ];
  text = readFile ./presenter.sh;
  meta = {
    licenses = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = name;
  };
}
