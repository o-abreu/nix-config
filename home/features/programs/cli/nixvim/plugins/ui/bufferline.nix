{
  programs.nixvim.plugins = {
    bufferline = {
      enable = true;
      lazyLoad.settings.event = [
        "BufReadPre"
        "BufNewFile"
        "TermOpen"
      ];
      settings.options = {
        diagnostics = "nvim_lsp";
        diagnostics_indicator =
          # lua
          ''
            function(count, level, diagnostics_dict, context)
              local s = ""
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                or (e == "warning" and " " or "" )
                if(sym ~= "") then
                  s = s .. " " .. n .. sym
                end
              end
              return s
            end
          '';

        groups.options.toggle_hidden_on_enter = true;
        show_buffer_close_icons = false;
        show_buffer_icons = true;
        show_close_icon = false;
        sort_by = "extension";
      };
    };
    faster.settings.behaviours = {
      bigfile.features_disabled = ["bufferline"];
      bigfile_hugefiles.features_disabled = ["bufferline"];
    };
  };
}
