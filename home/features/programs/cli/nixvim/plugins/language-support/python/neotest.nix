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
    };
  };
}
