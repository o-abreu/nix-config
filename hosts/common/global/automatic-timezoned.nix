{ lib, ... }:
{
  time.timeZone = lib.mkForce null; # INFO: mkForce setups value to be overriden by automatic timezone detection.
  services.automatic-timezoned.enable = true;

  # INFO: Workaround for https://github.com/NixOS/nixpkgs/issues/478774
  # GNOME disables the GeoClue demo agent ("GNOME has its own geoclue agent"),
  # but its agent only runs inside a GNOME session. On this Hyprland/Hydenix
  # setup there is no usable agent, so automatic-timezoned fails with a
  # "Remote peer disconnected" error and the timezone stays UTC.
  # Force the demo agent on so GeoClue can authorize location requests.
  services.geoclue2.enableDemoAgent = lib.mkForce true; # GNOME sets it to false
}
