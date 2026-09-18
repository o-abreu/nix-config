# INFO: presenterm.nvim — author and run presenterm presentations from Neovim.
#
# Nixvim has no upstream module for this plugin, so it is defined here following
# nixvim's FAQ ("How do I use a plugin not yet merged into Nixvim"). The package
# itself is exposed by `overlays/vim-plugins.nix`.
#
# `mkNeovimPlugin` declares `options.plugins.presenterm-nvim.*`, so this is a
# nixvim module rather than a host module. It is portable: import it into
# `programs.nixvim.imports` under Home Manager, or into the top-level `imports`
# of a standalone nixvim configuration. Exposed through `outputs.nixvimModules`.

{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
{
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "presenterm-nvim";
      # The Lua module is `presenterm`, not `presenterm-nvim`.
      moduleName = "presenterm";
      package = "presenterm-nvim";
      url = "https://github.com/Piotr1215/presenterm.nvim";
      maintainers = [ ];

      description = ''
        Author and manage [presenterm](https://github.com/mfontanini/presenterm)
        presentations from Neovim: slide navigation and editing, partials, column
        layouts, code execution, and a preview with optional bi-directional sync.
      '';

      settingsOptions = {
        slide_marker = defaultNullOpts.mkStr "<!-- end_slide -->" ''
          Slide separator marker.
        '';

        partials = {
          directory = defaultNullOpts.mkStr "_partials" ''
            Directory, relative to the presentation, holding partial files.
          '';
          resolve_relative = defaultNullOpts.mkBool true ''
            Resolve partial paths relative to the current file.
          '';
        };

        preview = {
          command = defaultNullOpts.mkStr "presenterm" ''
            Command used to spawn the preview.
          '';
          presentation_preview_sync = defaultNullOpts.mkBool false ''
            Keep the buffer and the preview in sync in both directions. Requires the
            presenterm footer to show slide numbers.
          '';
          login_shell = defaultNullOpts.mkBool true ''
            Spawn the preview through a login shell so `PATH` and environment
            variables are available.
          '';
        };

        picker.provider =
          defaultNullOpts.mkNullable
            (types.enum [
              "telescope"
              "fzf"
              "snacks"
              "builtin"
            ])
            null
            ''
              Picker used for slide/partial/layout selection. When `null`, the provider
              is auto-detected in the order telescope > fzf > snacks > builtin.
            '';

        default_keybindings = defaultNullOpts.mkBool false ''
          Set up the plugin's default buffer-local keymaps under `<leader>s`.

          > [!WARNING]
          > These collide with the snacks picker Search group
          > (`<leader>s{n,c,d,j,l,r}`).
        '';

        on_attach = defaultNullOpts.mkLuaFn null ''
          Called with the buffer number when presenterm activates for that buffer.
        '';
      };

      settingsExample = {
        preview.presentation_preview_sync = true;
        picker.provider = "snacks";
      };
    })
  ];

  # INFO: Disabled by default, like every nixvim plugin. Enabling is independent
  # of any host program (e.g. the Home Manager `programs.presenterm` module);
  # consumers opt in with `programs.nixvim.plugins.presenterm-nvim.enable`.
  # Only the preview needs the `presenterm` CLI on `PATH`; the rest of the
  # plugin works without it.
  plugins.presenterm-nvim = {
    # INFO: Configuring `settings` makes nixvim default `lazyLoad.enable` to
    # true. presenterm registers its auto-activation FileType autocmd inside
    # `plugin/presenterm.lua`, which cannot fire for the buffer that triggers
    # the load, so the plugin must be eager.
    lazyLoad.enable = lib.mkDefault false;

    settings = {
      # The plugin's defaults collide with the snacks Search group, so override
      # this or define your own maps instead.
      default_keybindings = lib.mkDefault true;
    };
  };
}
