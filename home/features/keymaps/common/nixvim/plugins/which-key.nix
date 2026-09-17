{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.which-key.settings.spec = map (m: m // { mode = "n"; }) [
      {
        __unkeyed-1 = "<leader>u";
        group = "UI/UX";
      }

      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
    ];
  };
}
