{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps =
      map
        (
          m:
          m
          // {
            mode = m.mode or "n";
            options = {
              expr = true;
              silent = true;
            };
          }
        )
        [
          {
            action = "'Nn'[v:searchforward].'zv'";
            key = "n";
            options.desc = "Next search result";
          }

          {
            action = "'Nn'[v:searchforward]";
            key = "n";
            options.desc = "Next search result";
            mode = [
              "o"
              "x"
            ];
          }

          {
            action = "'nN'[v:searchforward].'zv'";
            key = "N";
            options.desc = "Previous search result";
          }

          {
            action = "'nN'[v:searchforward]";
            key = "N";
            options.desc = "Previous search result";
            mode = [
              "o"
              "x"
            ];
          }
        ];
  };
}
