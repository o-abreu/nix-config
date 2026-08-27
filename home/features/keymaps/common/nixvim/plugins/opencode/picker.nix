{ lib, options, ... }:
{
  config = lib.mkIf (options ? programs.nixvim) {
    programs.nixvim.plugins.snacks.settings.picker =
      let
        bindings = {
          input.keys = {
            "<M-a>" = {
              __unkeyed-1 = "opencode_send";
              mode = "i";
            };
            "." = "opencode_send";
          };
          list.keys."." = "opencode_send";
        };
      in
      {
        actions.opencode_send.__raw = ''
          function(picker)
            local items = vim.tbl_map(function(item)
              return item.file
                and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
            end, picker:selected({ fallback = true }))
            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end
        '';
        win = bindings;
        sources.explorer.win = bindings;
      };
  };
}
