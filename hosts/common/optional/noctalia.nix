{
  config,
  ...
}:
{
  programs = {
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    noctalia-greeter.enable = true;
    hyprland = {
      enable = true;
      # Launch Hyprland via UWSM (Universal Wayland Session Manager) for
      # full systemd user-session integration. `programs.hyprland.withUWSM`
      # also enables `programs.uwsm`, which installs uwsm's systemd *user*
      # units (wayland-session-bindpid@, wayland-session-waitenv, ...) via
      # `systemd.packages`. Those units are required when a session is
      # started through `start-hyprland`.
      withUWSM = true;
    };
  };

  # The greeter user (auto-created by greetd) runs the noctalia-greeter
  # compositor, which needs access to the GPU/DRM devices.
  users.users.greeter.extraGroups = [ "video" "render" ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TEMP WORKAROUND: the noctalia-greeter compositor cannot scan out its
  # cursor buffer (AR24 + compressed modifier) on this AMD GPU, so it keeps
  # flashing and returning to the login screen. Bypass the greeter and start
  # a Hyprland session directly. With `hyprland.withUWSM` enabled, using
  # `start-hyprland` is correct (uwsm units are present).
  services.greetd.settings.default_session = {
    user = "abreu";
    command = "${config.programs.hyprland.package}/bin/start-hyprland";
  };
}
