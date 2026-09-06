{ config, ... }: {
  programs.nixvim = {
    plugins = {
      molten = {
        enable = true;
        settings = {
          # Visuals and UI
          cover_comment_lines = false;

          # Inline execution feedback
          auto_open_output = false;
          output_virt_lines = true;
          virt_lines_off_by_1 = true;
        };
      };
      quarto.settings.codeRunner = {
        enabled = true;
        default_method = "molten";
      };
      lualine.settings.sections.lualine_c = [
        {
          # Build the display string from Molten's status API.
          # initialized() returns the attached notebook filename (empty if none).
          # kernels()     returns the kernel name and status (e.g. "python3: idle").
          # We join them as "notebook: kernel" so both are visible at a glance.
          __unkeyed-1.__raw = ''
            function()
              local init_status = require("molten.status").initialized()
              local kernel_status = require("molten.status").kernels()
              local info = (init_status ~= "" and init_status .. ": ") .. kernel_status
              return info ~= "" and info or ""
            end
          '';

          # Only show this component when Molten is actually attached to a notebook.
          # This hides it completely during normal (non-notebook) editing.
          condition.__raw = ''
            function() return require("molten.status").initialized() ~= "" end
          '';
          padding = {
            left = 1;
            right = 1;
          };

          # Use the Stylix theme accent (base09) when available, otherwise
          # fall back to a warm orange that fits most dark color schemes.
          color = {
            fg =
              if config.stylix.enable or false then config.lib.stylix.colors.withHashtag.base09 else "#ff9e64";
            gui = "bold";
          };
        }

      ];
    };
    userCommands.MoltenInitVenv = {
      desc = "Initialize Molten for the active Python virtual environment";
      command.__raw = builtins.readFile ./init.lua;
    };
  };
}
