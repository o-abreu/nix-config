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
        enable =
          cfg.enable && ((cfg.settings.gitbrowse.enabled or false) == true) && (config.programs.git.enable);
        bind = {
          action.__raw = "function () Snacks.gitbrowse() end";
        };
      in
      lib.mkIf enable (
        map (m: m // bind) [
          {
            key = "<leader>go";
            mode = "n";
            options.desc = "Open file in its remote repo";
          }
          {
            key = "<leader>o";
            mode = "v";
            options.desc = "Open selection its remote repo";
          }
        ]
      );
  };
}
