{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig =
      with lib;
      builtins.readDir ./modules
      |> builtins.attrNames
      |> map (f: removeSuffix ".lua" f)
      |> flip genAttrs (f: ./modules/${f}.lua);
    plugins.tabline-wez = inputs.tabline-wez;
  };

  # INFO: Pre-create $XDG_RUNTIME_DIR/wezterm so wezterm's ssh-agent proxy
  # symlink does not race against runtime dir creation at startup
  # (upstream wezterm issue #6547).
  systemd.user.tmpfiles.rules = [ "d %t/wezterm - - -" ];

  home = {
    sessionVariables.TERMINAL = "wezterm";
    packages = [ pkgs.wezterm-floating ];
  };
}
