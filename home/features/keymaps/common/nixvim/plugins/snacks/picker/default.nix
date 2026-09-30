{
  programs.nixvim.plugins.snacks.settings.picker =
    let
      bindings = {
        input.keys."<C-p>" = {
          __unkeyed-1 = "toggle_focus";
          mode = [
            "n"
            "i"
          ];
        };
        list.keys."<C-p>" = "toggle_focus";
      };
    in
    {
      win = bindings;
      sources.explorer.win = bindings;
    };
}
