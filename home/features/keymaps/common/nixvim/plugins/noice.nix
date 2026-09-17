{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps = lib.mkIf config.programs.nixvim.plugins.noice.enable [
      {
        key = "<C-s>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("noice").cmd.signature()
            end
          '';
        options = {
          silent = true;
          desc = "Noice signature help";
        };
      }
    ];
  };
}
