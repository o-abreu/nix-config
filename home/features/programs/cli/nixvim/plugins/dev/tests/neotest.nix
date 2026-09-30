{
  programs.nixvim = {
    plugins.neotest = {
      enable = true;
      lazyLoad.enable = true;
      settings.floating.border = "rounded";
    };

    # Neotest publishes failures as diagnostics under its own "neotest"
    # namespace. Its error messages are often multi-line (stack traces,
    # assertion diffs), which break virtual text rendering. Flatten each
    # message to a single, whitespace-normalized line.
    extraConfigLuaPre =
      # lua
      ''
        vim.diagnostic.config({
          virtual_text = {
            format = function(diagnostic)
              local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
              return message
            end,
          },
        }, vim.api.nvim_create_namespace("neotest"))
      '';
  };
}
