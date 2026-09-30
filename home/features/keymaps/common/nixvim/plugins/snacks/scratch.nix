{ config, lib, ... }:
{
  programs.nixvim =
    let
      cfg = config.programs.nixvim.plugins.snacks;
      enable = cfg.enable && ((cfg.settings.picker.enabled or false) == true);
      mkAction = func: { __raw = "function() Snacks.picker.${func}() end"; };
      prefix = "<leader>N";
    in
    {
      plugins.which-key.settings.spec = lib.optional enable {
        __unkeyed-1 = prefix;
        group = "Notes";
        icon = " ";
      };

      keymaps =
        [
          {
            key = prefix + "n";
            action = mkAction "scratch";
            options.desc = "New Scratch Buffer";
          }
          {
            key = prefix + "s";
            action = mkAction "scratch.select";
            options.desc = "Select Scratch Buffer";
          }
        ]
        |> map (m: m // { mode = "n"; })
        |> lib.mkIf enable;
    };
}
