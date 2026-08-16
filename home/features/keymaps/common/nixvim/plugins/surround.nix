{
  config,
  lib,
  options,
  ...
}:
with lib;
{
  config = mkIf (options ? programs.nixvim) {
    programs.nixvim =
      let
        key = "s";
        cfg = config.programs.nixvim.plugins.nvim-surround;
        plug = command: "<Plug>(nvim-surround-${command})";
      in
      {
        globals."nvim_surround_no_*_mappings" = lib.mkIf cfg.enable true;
        keymaps = lib.mkIf cfg.enable [
          {
            action = plug "insert";
            key = "<C-g>${key}";
            mode = "i";
            options.desc = "Add a surrounding pair around the cursor";
          }
          {
            action = plug "insert-line";
            key = "<C-g>${toUpper key}";
            mode = "i";
            options.desc = "Add a surrounding pair on new lines created around the cursor";
          }
          {
            action = plug "normal";
            key = key;
            mode = "n";
            options.desc = "Add a surrounding pair around a motion";
          }
          {
            action = plug "normal-cur";
            key = key + key;
            mode = "n";
            options.desc = "Add a surrounding the current line";
          }
          {
            action = plug "normal-line";
            key = toUpper key;
            mode = "n";
            options.desc = "Add a surrounding pair around motion, on new lines created around it";
          }
          {
            action = plug "normal-cur-line";
            key = key + key |> toUpper;
            mode = "n";
            options.desc = "Add a surrounding pair around the current line, on new lines created around it";
          }
          {
            action = plug "visual";
            key = key;
            mode = "x";
            options.desc = "Add a surrounding pair around a visual selection";
          }
          {
            action = plug "visual-line";
            key = "g${key}";
            mode = "x";
            options.desc = "Add a surrounding pair around a visual selection, on new lines";
          }
          {
            action = plug "delete";
            key = "d${key}";
            mode = "n";
            options.desc = "Delete a surrounding pair";
          }
          {
            action = plug "change";
            key = "c${key}";
            mode = "n";
            options.desc = "Change a surrounding pair";
          }
          {
            action = plug "change-line";
            key = "c${toUpper key}";
            mode = "n";
            options.desc = "Change a surrounding pair, putting replacements on new lines";
          }
        ];
      };
  };
}
