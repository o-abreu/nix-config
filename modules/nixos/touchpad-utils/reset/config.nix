{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.touchpadReset;

  unit = "touchpad-reset.service";
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg.device != null) {
      programs.touchpadReset.enable = lib.mkDefault true;
    })
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.device != null;
          message = "programs.touchpadReset: 'device' must be set when the module is enabled.";
        }
      ];

      programs.touchpadReset.rootPackage = pkgs.writeShellApplication {
        name = "touchpad-reset-root";
        runtimeInputs = [ pkgs.kmod ];
        text = import ./_script-root.nix { inherit cfg; };
      };

      programs.touchpadReset.package = pkgs.writeShellApplication {
        name = "touchpad-reset";
        runtimeInputs = [
          pkgs.libnotify
          config.systemd.package
        ];
        text = import ./_script-user.nix { inherit unit; };
      };

      # INFO: Not enabled (no wantedBy): the unit only ever runs on demand from
      #       the user command, or directly from the resume hook below.
      systemd.services.touchpad-reset = {
        description = "Re-probe the I2C-HID touchpad";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.rootPackage}/bin/touchpad-reset-root";
        };
      };

      # INFO: Let wheel start this one unit without authentication, so the
      #       keybind works with a dead touchpad and no password prompt.
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "${unit}" &&
              action.lookup("verb") == "start" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';

      environment.systemPackages = [ cfg.package ];

      # INFO: post-resume.service already runs as root, so it calls the helper
      #       directly instead of going through polkit.
      powerManagement.resumeCommands = lib.mkIf cfg.onResume ''
        ${cfg.rootPackage}/bin/touchpad-reset-root || true
      '';
    })
  ];
}
