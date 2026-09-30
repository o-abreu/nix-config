{config, ...}: {
  _module.args.vimtex = {
    inherit (config.programs.nixvim.plugins.vimtex) enable;
    prefix = "<localleader>";
    bind = {
      key,
      plug ? null,
      mode ? "n",
      desc,
    }: {
      inherit key mode;
      action = "<Plug>(vimtex-${
        if plug != null
        then plug
        else key
      })";
      options = {
        buffer = true;
        silent = true;
        inherit desc;
      };
    };
  };
  programs.nixvim.globals.vimtex_mappings_enabled = false;
}
