{
  programs.nixvim.plugins.presenterm-nvim.settings = {
    default_keybindings = false;
    on_attach.__raw = builtins.readFile ./init.lua;
  };
}
