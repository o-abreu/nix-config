{
  lib,
  ...
}:
{
  wayland.windowManager.hyprland.settings.window_rule =
    let
      pip = "picture-in-picture";
      pipRules =
        {
          float = true;
          keep_aspect_ratio = true;
          move = [
            73
            72
          ];
          size = "25%";
          pin = true;
        }
        |> lib.mapAttrsToList (name: value: { ${name} = value; } // { match.tag = pip; });
    in
    [
      {
        match.title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$";
        tag = "+${pip}";
      }
    ]
    ++ pipRules;
}
