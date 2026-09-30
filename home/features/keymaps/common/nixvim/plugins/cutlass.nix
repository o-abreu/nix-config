{ config, lib, ... }:
{
  programs.nixvim =
    let
      cfg = config.programs.nixvim.plugins.cutlass-nvim;
    in
    {
      plugins.cutlass-nvim.settings.cut_key = "m";

      # NOTE: Solve default "m" keybind conflict: mm and M are handled internally by Cutlass when cut_key is set.
      keymaps =
        [
          {
            key = "gm";
            action = "m";
            options = {
              desc = "Set mark";
              silent = true;
            };
          }
          {
            key = "m";
            action = "m";
            options.desc = "Cut operation";
          }
        ]
        |> map (m: m // { mode = "n"; })
        |> lib.mkIf cfg.enable;
    };
}
