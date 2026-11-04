{
  config,
  lib,
  ...
}: let
  cfg = config.programs.nixvim.plugins.csvview;
  filetypes = ["csv" "tsv"];
in {
  programs.nixvim = {
    files =
      filetypes
      |> map (ft: "ftplugin/${ft}.lua")
      |> lib.flip lib.genAttrs (_:
        lib.mkIf cfg.enable {
          keymaps = [
            {
              key = "<localleader>t";
              action = "<cmd>CsvViewToggle<cr>";
              mode = "n";
              options = {
                buffer = true;
                silent = true;
                desc = "Toggle CSV view";
              };
            }

            # INFO: Reports the detected delimiter, header line and dimensions,
            # which is what you need when auto-detection guesses wrong.
            {
              key = "<localleader>i";
              action = "<cmd>CsvViewInfo<cr>";
              mode = "n";
              options = {
                buffer = true;
                silent = true;
                desc = "CSV buffer info";
              };
            }
          ];
        });

    plugins.csvview.settings.keymaps = {
      textobject_field_inner = {
        __unkeyed-1 = "if";
        mode = ["o" "x"];
      };
      textobject_field_outer = {
        __unkeyed-1 = "af";
        mode = ["o" "x"];
      };
      jump_next_field_end = {
        __unkeyed-1 = "<Tab>";
        mode = ["n" "v"];
      };
      jump_prev_field_end = {
        __unkeyed-1 = "<S-Tab>";
        mode = ["n" "v"];
      };
      jump_next_row = {
        __unkeyed-1 = "<Enter>";
        mode = ["n" "v"];
      };
      jump_prev_row = {
        __unkeyed-1 = "<S-Enter>";
        mode = ["n" "v"];
      };
    };
  };
}
