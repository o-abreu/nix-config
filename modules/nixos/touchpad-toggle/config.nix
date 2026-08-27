{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hyprland.touchpadToggle;
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg.name != null) {
      programs.hyprland.touchpadToggle.enable = lib.mkDefault true;
    })
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "programs.hyprland.touchpadToggle: 'name' must be set when the toggle is enabled.";
        }
      ];

      programs.hyprland.touchpadToggle.package = pkgs.writeShellApplication {
        name = "touchpad-toggle";
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
