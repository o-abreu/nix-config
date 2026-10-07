{ lib, ... }:
with lib;
{
  # INFO: Extends the home-manager `programs.librewolf` module. Add-ons are
  #       force-installed through the enterprise `ExtensionSettings` policy,
  #       which auto-grants their install-time permissions and auto-enables
  #       them, unlike sideloading via `profiles.<name>.extensions.packages`.
  options.programs.librewolf.extensions = mkOption {
    type = types.listOf types.package;
    default = [ ];
    example = literalExpression ''
      with pkgs.firefox-addons; [
        darkreader
        noscript
      ]
    '';
    description = ''
      Firefox add-ons (typically from `pkgs.firefox-addons`) to force-install
      for all LibreWolf profiles. Each package must expose an `addonId`; its
      `src` (the raw `.xpi` store path) is used as the install URL.
    '';
  };
}
