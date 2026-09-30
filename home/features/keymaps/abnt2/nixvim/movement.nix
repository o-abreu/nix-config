{ lib, ... }: {
  programs.nixvim = {
    plugins.hardtime.settings =
      let
        dir = [
          "<Up>"
          "<Down>"
          "<Left>"
          "<Right>"
        ];
      in
      {
        disabled_keys = lib.genAttrs dir (_: [ ]);
        restricted_keys = lib.genAttrs dir (_: [ "" ]);
      };

    keymaps =
      map
        (
          m:
          m
          // {
            mode = [
              "n"
              "o"
              "x"
            ];
          }
        )
        [
          {
            action = "v:count == 0? 'gj' : 'j'";
            key = "k";
            options = {
              desc = "Move cursor down";
              expr = true;
              silent = true;
            };
          }

          {
            action = "v:count == 0? 'gk' : 'k'";
            key = "l";
            options = {
              desc = "Move cursor up";
              expr = true;
              silent = true;
            };
          }

          {
            action = "h";
            key = "j";
            options = {
              desc = "Move cursor left";
              silent = true;
            };
          }

          {
            action = "l";
            key = "ç";
            options = {
              desc = "Move cursor right";
              silent = true;
            };
          }

          {
            action = "gg^";
            key = "gg";
            options.desc = "Move cursor to the first character";
          }

          {
            action = "GG$";
            key = "G";
            options.desc = "Move cursor to the last character";
          }

          {
            action = "g^";
            key = "^";
            options.desc = "Move cursor to the first character linewise";
          }

          {
            action = "g0";
            key = "0";
            options.desc = "Move cursor to the beggining of the line";
          }

          {
            action = "g$";
            key = "$";
            options.desc = "Move cursor to the end of the line";
          }
        ];
  };
}
