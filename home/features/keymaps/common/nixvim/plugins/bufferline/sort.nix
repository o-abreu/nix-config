{ bufferline, lib, ... }:
{
  programs.nixvim =
    let
      prefix = bufferline.prefix + "s";
    in
    {
      plugins.which-key.settings.spec = lib.optional bufferline.cfg.enable {
        __unkeyed-1 = prefix;
        group = "Sort";
        icon = "󱂬 "; # Nerd Font icon for sorting/descending lines
      };
      keymaps =
        [
          {
            key = prefix + "e";
            action.__raw =
              # lua
              ''function() require("bufferline.commands").sort_by "extension" end'';
            options.desc = "Sort buffers by extension";
          }
          {
            key = prefix + "i";
            action.__raw =
              # lua
              ''function() require("bufferline.commands").sort_by "id" end'';
            options.desc = "Sort buffers by buffer number";
          }
          {
            key = prefix + "m";
            action.__raw =
              # lua
              ''
                function()
                  require("bufferline.commands").sort_by(
                    function(a, b)
                      return a.modified and not b.modified
                    end
                  )
                end
              '';
            options.desc = "Sort buffers by buffer number";
          }
          {
            key = prefix + "p";
            action.__raw =
              # lua
              ''function() require("bufferline.commands").sort_by "directory" end'';
            options.desc = "Sort buffers by extension";
          }
          {
            key = prefix + "r";
            action.__raw =
              # lua
              ''function() require("bufferline.commands").sort_by "relative_directory" end'';
            options.desc = "Sort buffers by extension";
          }
        ]
        |> map (m: m // { mode = "n"; })
        |> lib.optionals bufferline.cfg.enable;
    };
}
