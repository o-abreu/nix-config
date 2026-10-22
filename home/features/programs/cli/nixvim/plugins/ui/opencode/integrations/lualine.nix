{
  programs.nixvim.plugins.lualine.settings.sections.lualine_z = [
    "location"
    {
      __unkeyed-1.__raw = "function() local ok, s = pcall(require, 'opencode') return ok and s.statusline() or '' end";
    }
  ];
}
