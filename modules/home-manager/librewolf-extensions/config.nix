{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.librewolf;
  addons = filter (addon: addon ? addonId) cfg.extensions;
in {
  config = mkIf cfg.enable {
    programs.librewolf.policies.ExtensionSettings =
      addons
      |> map (addon: {
        name = addon.addonId;
        value = {
          installation_mode = "force_installed";
          install_url = "file://${addon.src}";
        };
      })
      |> listToAttrs;
  };
}
