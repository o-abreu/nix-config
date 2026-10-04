{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.nixvim.plugins.smart-splits;
  bind = key: action: desc: {
    inherit key;
    action.__raw = "function() require('smart-splits').${action}() end";
    options = {inherit desc;};
  };
in {
  programs = {
    nixvim.keymaps =
      [
        ./_move-cursor.nix
        ./_resize-window.nix
        ./_swap-buffers.nix
      ]
      |> map (m: import m {inherit bind;})
      |> lib.concatLists
      |> lib.mkIf cfg.enable;

    # WezTerm integration
    wezterm = lib.mkIf cfg.enable {
      extraConfig."keybinds.smart-splits" = ./smart-splits.lua;
      plugins = [pkgs.weztermPlugins.smart-splits-nvim];
    };
  };
}
