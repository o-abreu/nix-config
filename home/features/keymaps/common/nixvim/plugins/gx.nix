{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.gx = {
      disableNetrwGx = true;
      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "gx";
          __unkeyed-2 = "<cmd>Browse<cr>";
          mode = [
            "n"
            "x"
          ];
          silent = true;
          desc = "Open filepath or URI under cursor";
        }
      ];
    };
  };
}
