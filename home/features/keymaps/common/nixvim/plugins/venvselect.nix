{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.venv-selector;
in

{
  config = lib.optionalAttrs (options ? programs.nixvim) {
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
  };
}
