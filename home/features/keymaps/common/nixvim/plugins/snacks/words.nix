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
        cfg = config.programs.nixvim.plugins.snacks;
        enable = cfg.enable && ((cfg.settings.words.enabled or false) == true);
        mkAction = direction: {
          __raw = "function() Snacks.words.jump(${
            if direction == "next" then "vim.v.count1" else "-vim.v.count1"
          }) end";
        };
      in
      [
        {
          key = "]]";
          action = mkAction "next";
          options.desc = "Next Reference";
        }
        {
          key = "[[";
          action = mkAction "previous";
          options.desc = "Previous Reference";
        }
      ]
      |> map (m: m // { mode = "n"; })
      |> lib.optionals enable;
  };
}
