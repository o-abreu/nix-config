{
  programs.nixvim.plugins.neotest = {
    adapters.python = {
      enable = true;
      settings.python.__raw = ''
        function()
          local venv = vim.fn.getenv('VIRTUAL_ENV')
          if venv ~= "" and venv ~= vim.NIL then
            return venv .. "/bin/python"
          end
          return "python"
        end
      '';

      # INFO: `dap-python` is already enabled in `default.nix`, so this is what
      # makes `<leader>Td` work for Python. `justMyCode = false` lets the
      # debugger step into the code under test rather than stopping only in
      # library code, which is the documented neotest-python recommendation.
      settings.dap.justMyCode = false;
    };
  };
}
