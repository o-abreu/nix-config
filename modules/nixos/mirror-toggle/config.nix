{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hyprland.mirrorToggle;
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg.main != null) {
      programs.hyprland.mirrorToggle.enable = lib.mkDefault true;
    })
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.main != null;
          message = "programs.hyprland.mirrorToggle: 'main' must be set when the toggle is enabled.";
        }
      ];

      programs.hyprland.mirrorToggle.package = pkgs.writeShellApplication {
        name = "mirror-toggle";
        runtimeInputs = [
          config.programs.hyprland.package
          pkgs.jq
          pkgs.libnotify
        ];
        text = import ./_script.nix { inherit cfg; };
      };

      environment.systemPackages = [ cfg.package ];
    })
  ];
}
