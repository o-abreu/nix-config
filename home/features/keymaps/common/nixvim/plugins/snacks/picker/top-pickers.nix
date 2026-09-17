{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps =
      let
        cfg = config.programs.nixvim.plugins;
        enable = cfg.snacks.enable && ((cfg.snacks.settings.picker.enabled or false) == true);
        mkAction = func: { __raw = "function() Snacks.picker.${func}() end"; };
      in
      [
        {
          key = "<leader><space>";
          action = mkAction "smart";
          options.desc = "Smart Find Files";
        }
        {
          key = "<leader>b<space>";
          action = mkAction "buffers";
          options.desc = "Search Buffers";
        }
        {
          key = "<leader>:";
          action = mkAction "command_history";
          options.desc = "Command History";
        }
      ]
      ++ lib.optional cfg.yanky.enable {
        key = "<leader>p";
        action = mkAction "yanky";
        options.desc = "Paste from yanky history";
      }

      |> map (m: m // { mode = "n"; })
      |> lib.mkIf enable;
  };
}
