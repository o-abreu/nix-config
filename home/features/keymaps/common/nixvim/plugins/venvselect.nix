{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.venv-selector;
in
{
  programs.nixvim.files = lib.mkIf cfg.enable {
    "ftplugin/python.lua".keymaps = [
      {
        mode = "n";
        key = "<Leader>lv";
        action = "<Cmd>VenvSelect<CR>";
        options = {
          buffer = true;
          silent = true;
          desc = "Select VirtualEnv";
        };
      }
    ];
  };
}
