{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) otter which-key;
  prefix = "<localleader>o";
in {
  programs.nixvim.files."ftplugin/quarto.lua" = lib.mkIf otter.enable {
    keymaps = [
      {
        key = prefix + "e";
        action.__raw = "function() require('otter').export() end";
        mode = "n";
        options.desc = "Export";
      }

      {
        key = prefix + "E";
        action.__raw = "function() require('otter').export(true) end";
        mode = "n";
        options.desc = "Export overwrite";
      }

      {
        key = prefix + "a";
        action.__raw = "function() require('otter').export_otter_as() end";
        mode = "n";
        options.desc = "Export as";
      }
    ];
    extraConfigLua =
      lib.mkIf which-key.enable
      # lua
      ''
        require("which-key").add({
          {
            "${prefix}",
            group = "Otter",
            icon = "🦦",
            mode = "n",
            buffer = true,
          }
        })
      '';
  };
}
