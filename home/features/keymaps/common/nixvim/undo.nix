{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps =
      [
        {
          key = ",";
          action = ",<c-g>u";
        }
        {
          key = ".";
          action = ".<c-g>u";
        }
        {
          key = ";";
          action = ";<c-g>u";
        }
        {
          key = "<CR>";
          action = "<c-g>u<CR>";
        }
      ]
      |> map (bind: {
        mode = "i";
        inherit (bind) key action;
        options.desc = "Undo break-point";
      });
  };
}
