{ pkgs, ... }: {
  home.packages = [ pkgs.trash-cli ];
  programs = {
    fish.shellAbbrs.tp = "trash-put";
    yazi.plugins = { inherit (pkgs.yaziPlugins) recycle-bin restore; };
  };
}
