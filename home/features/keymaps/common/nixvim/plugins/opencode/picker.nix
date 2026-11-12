{
  programs.nixvim.plugins.snacks.settings.picker = let
    bindings = {
      input.keys = {
        "<M-a>" = {
          __unkeyed-1 = "opencode_ask";
          mode = "i";
        };
        "." = "opencode_ask";
      };
      list.keys."." = "opencode_ask";
    };
  in {
    # INFO: Open the opencode ask input pre-filled with the context of the
    # cursor-focused / selected items.
    actions.opencode_ask.__raw = ''
      function(picker)
        local items = vim.tbl_map(function(item)
          return item.file
            and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
            or item.text
        end, picker:selected({ fallback = true }))
        require("opencode").ask(table.concat(items, ", ") .. " ")
      end
    '';
    win = bindings;
    sources.explorer.win = bindings;
  };
}
