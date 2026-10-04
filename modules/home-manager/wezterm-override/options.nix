{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.wezterm;
in
{
  meta.maintainers = [
    hm.maintainers.blmhemu
    maintainers.khaneliman
  ];

  disabledModules = [ "programs/wezterm.nix" ];

  options.programs.wezterm = with types; {
    enable = mkEnableOption "wezterm";

    package = lib.mkPackageOption pkgs "wezterm" { };

    # This module replaces HM's `programs/wezterm` wholesale, so it does not
    # implement `settings`. Stylix (master) still writes the wezterm target
    # through that option, and stylix's `mkTarget` discovers it by *touching*
    # `config ? programs.wezterm.settings` — which happens whenever the target
    # is defined, regardless of `stylix.targets.wezterm.enable = false`. That
    # turns the missing option into a hard eval error even for a disabled
    # target.
    #
    # Declaring an inert placeholder satisfies that existence check without
    # reintroducing the upstream module: nothing writes to this option, so the
    # generated `wezterm.lua` is unaffected.
    settings = mkOption {
      type = attrsOf anything;
      default = { };
      description = ''
        Placeholder only, to keep stylix's wezterm target evaluable. This
        module writes its Lua modules through `extraConfig` instead.
      '';
    };

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
      # Either form is accepted:
      #   * an attribute set, where the key *is* the plugin name;
      #   * a list, where each entry carries its own `name`, so a catalog entry
      #     can be passed straight through without restating the name.
      # `attrs` (not `submodule`) so `{ url, src }` values and bare
      # path-coercible attrsets are accepted without forced interpolation.
      # Strings are allowed only in the list form, as shorthand for a catalog
      # lookup.
      type = either (attrsOf (either path attrs)) (listOf (either path (either str attrs)));
      default = { };
      example = literalExpression ''
        {
          # Catalog entries, keyed by their own name
          plugins = with pkgs.weztermPlugins; [
            tabline-wez
            smart-splits-nvim
          ];

          # Bare names work too, as shorthand for the same lookup
          plugins = [ "wezterm-unicode-input" ];

          # Anything outside the catalog, under a name of our choosing
          plugins.my-plugin = {
            url = "https://github.com/user/my-plugin";
            src = inputs.my-plugin;
          };
        }
      '';
      description = ''
        The wezterm plugins to install. Each plugin must contain a
        {file}`plugin/init.lua` file. The module symlinks each one into
        {file}`$XDG_CONFIG_HOME/wezterm/plugins/<name>/`, making it accessible via
        {lua}`require("plugins.<name>")`.

        **List form.** Give a list of entries from {file}`pkgs.weztermPlugins`
        (see {file}`overlays/wezterm-plugins.nix`) and each is keyed by its own
        `name`, so the name is never restated:

        ```nix
        plugins = with pkgs.weztermPlugins; [ tabline-wez ];
        ```

        A bare string is accepted as shorthand for the same catalog lookup, and a
        hand-written `{ name, url, src; }` record works too. Lists merge by
        concatenation, so each feature module contributes its own entries; a name
        listed twice is an error rather than a silent last-one-wins.

        **Attribute-set form.** Use this to register a plugin under a name *other*
        than its own, or a source that is not in the catalog at all. Pick one form
        per configuration: Nixvim rejects an option that is an attribute set in one
        module and a list in another.

        **Registry layout.** Entries supplied with `url` and `src` — catalog
        entries, or explicit `{ url, src; }` values — are additionally installed
        using wezterm's official URL-encoded directory layout and registered in
        {lua}`wezterm.plugin.list()` via a generated shim. This makes plugins that
        assume installation through wezterm's built-in plugin manager (e.g. by
        indexing {lua}`wezterm.plugin.list()[1]` at load time) work unpatched.
        Sources without a `url` (paths or bare flake inputs) get the plain
        {lua}`require("plugins.<name>")` layout only.

        Only install plugins that are loaded exclusively via
        {lua}`require("plugins.<name>")`: a plugin that is also cloned by wezterm's
        plugin manager would appear twice in the list.

        The name is a Lua module path segment: hyphens are fine, but a `.`
        silently breaks {lua}`require("plugins.<name>")`, because Lua expands `.`
        to `/` and would look for `plugins/my/plugin.lua` while the directory is
        literally `my.plugin`.
      '';
    };

    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.stylix.targets.wezterm.enable;
        message = ''
          stylix.targets.wezterm.enable is true, but `programs.wezterm.settings`
          is only an inert placeholder in this configuration (see the note on
          the option above). Stylix would write its colors there and they would
          be silently dropped: this module generates `wezterm.lua` from
          `extraConfig` and `colorSchemes` only.

          Either keep the target disabled — see
          `home/features/desktop-environment/stylix/astrodark-theme/overrides/wezterm.nix`,
          which themes wezterm from `config.lib.stylix.colors` instead — or
          migrate the theme to write through `programs.wezterm.extraConfig`.
        '';
      }
    ];
  };
}
