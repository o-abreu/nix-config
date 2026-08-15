{ pkgs, ... }: {
  home.packages = [ pkgs.trash-cli ];
  programs = {
    fish.shellAbbrs.rm = "trash-put";
    yazi.plugins = { inherit (pkgs.yaziPlugins) recycle-bin restore; };
  };
}
