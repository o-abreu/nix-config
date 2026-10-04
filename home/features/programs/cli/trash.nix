{pkgs, ...}: let
  pkg = pkgs.trash-cli;
in {
  home.packages = [pkg];
  programs = {
    fish.shellAbbrs.tp = "trash-put";
    yazi = {
      plugins = {inherit (pkgs.yaziPlugins) recycle-bin restore;};
      # The recycle-bin and restore plugins shell out to trash-list,
      # trash-restore, trash-empty and trash-rm. Keep trash-cli in yazi's
      # wrapper PATH so they work regardless of how yazi was launched.
      extraPackages = [pkg];
    };
  };
}
