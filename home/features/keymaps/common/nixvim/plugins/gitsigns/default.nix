{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.gitsigns.settings =
      let
        cfg = config.programs.nixvim.plugins.which-key;
      in
      lib.mkIf cfg.enable {
        on_attach.__raw = builtins.readFile ./init.lua;
      };
  };
}
