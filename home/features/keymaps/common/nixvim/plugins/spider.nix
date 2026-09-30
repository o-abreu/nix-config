{ config, lib, ... }:
{
  programs.nixvim.keymaps =
    let
      cfg = config.programs.nixvim.plugins.spider;
      bind = key: desc: {
        inherit key;
        action.__raw = "function() require('spider').motion('${key}') end";
        options = { inherit desc; };
      };
    in
    lib.mkIf cfg.enable [
      (bind "w" "Next word")
      (bind "e" "Next end of word")
      (bind "b" "Previous word")
      (bind "ge" "Previous end of word")
    ];
}
