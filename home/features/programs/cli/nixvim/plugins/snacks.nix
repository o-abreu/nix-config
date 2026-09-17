{
  config,
  lib,
  ...
}:
{
  programs.nixvim.plugins = {
    snacks = {
      enable = true;
      settings =
        [
          "bufdelete"
          "dim"
          "indent"
          "input"
          "picker"
          "profiler"
          "quickfile"
          "rename"
          "scroll"
          "statuscolumn"
          "terminal"
          "toggle"
          "zen"
        ]
        ++ lib.optional config.programs.git.enable "gitbrowse"
        |> (
          l:
          lib.genAttrs l (_: {
            enabled = true;
          })
        );
    };
    faster.settings.behaviours.bigfile.features_disabled = [ "snacks" ];
  };
}
