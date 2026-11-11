{
  pkgs,
  lib,
  ...
}:
with lib;
let
  name = "screenshot";
in
pkgs.writeShellApplication {
  name = name;
  runtimeInputs = with pkgs; [
    coreutils
    grim
    grimblast
    hyprland
    jq
    libnotify
    slurp
    wl-clipboard
    xdg-user-dirs
  ];
  text = readFile ./screenshot.sh;
  meta = {
    licenses = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = name;
  };
}
