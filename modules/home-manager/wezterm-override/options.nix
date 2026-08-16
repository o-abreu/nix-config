{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  meta.maintainers = [
    hm.maintainers.blmhemu
    maintainers.khaneliman
  ];

  disabledModules = [ "programs/wezterm.nix" ];

  options.programs.wezterm = with types; {
    enable = mkEnableOption "wezterm";

    package = lib.mkPackageOption pkgs "wezterm" { };

    # CHANGED: Now accepts an attribute set of paths or strings
    extraConfig = mkOption {
      type = attrsOf (either lines path);
      default = { };
      example = literalExpression ''
        {
          "appearance" = ./lua/appearance.lua;
          "keybinds.overrides" = '''
            local M = {}
            function M.apply_to_config(config)
              config.keys = { ... }
            end
            return M
          ''';
        }
      '';
      description = ''
        Attribute set of WezTerm modules.
        The key is the module namespace (e.g. `keybinds.overrides`), which corresponds
        to `require("modules.keybinds.overrides")`.
        The value is either the path to a Lua file or a string containing the Lua code.
      '';
    };

    colorSchemes = mkOption {
      type =
        let
          tomlFormat = pkgs.formats.toml { };
        in
        attrsOf (tomlFormat.type);
      default = { };
      description = ''
        Attribute set of additional color schemes to be written to
        {file}`$XDG_CONFIG_HOME/wezterm/colors`.
      '';
    };

    plugins = mkOption {
      # `attrs` (not `submodule`) so bare flake inputs — path-coercible
      # attrsets — are accepted without forced interpolation.
      type = attrsOf (either path attrs);
      default = { };
      example = literalExpression ''
        {
          # URL inferred from flake.lock; registered in wezterm.plugin.list()
          tabline-wez = inputs.tabline-wez;
          # Manual override for sources not in flake.lock
          my-plugin = {
            url = "https://github.com/user/my-plugin";
            src = inputs.my-plugin;
          };
        }
      '';
      description = ''
        Attribute set mapping plugin names to their sources (typically
        flake inputs). Each source must contain a {file}`plugin/init.lua`
        file. The module will symlink each plugin into
        {file}`$XDG_CONFIG_HOME/wezterm/plugins/`, making it accessible
        via {lua}`require("plugins.<name>")`.

        Plugins whose canonical repository URL can be determined — either
        from flake.lock (github/gitlab inputs, matched by locked revision)
        or from an explicit `{ url, src }` attribute set — are additionally
        installed using wezterm's official URL-encoded directory layout
        and registered in {lua}`wezterm.plugin.list()` via a generated
        shim. This makes plugins that assume installation through
        wezterm's built-in plugin manager (e.g. by indexing
        {lua}`wezterm.plugin.list()[1]` at load time) work unpatched.

        Only use this for plugins loaded exclusively via
        {lua}`require("plugins.<name>")`: a plugin that is also cloned by
        wezterm's plugin manager would appear twice in the list.
      '';
    };

    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };
  };
}
