{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig =
      with lib;
      builtins.readDir ./modules |> builtins.attrNames |> flip genAttrs (f: ./modules/${f});
    plugins.tabline-wez = pkgs.weztermPlugins.tabline-wez;
  };

  # INFO: Pre-create $XDG_RUNTIME_DIR/wezterm so wezterm's ssh-agent proxy
  # symlink does not race against runtime dir creation at startup
  # (upstream wezterm issue #6547).
  systemd.user.tmpfiles.rules = [ "d %t/wezterm - - -" ];

  home = {
    sessionVariables.TERMINAL = lib.getExe config.programs.wezterm.package;
    packages = [ pkgs.wezterm-floating ];
  };
}
