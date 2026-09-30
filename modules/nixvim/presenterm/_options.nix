{ lib }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "presenterm";
  moduleName = "presenterm";
  package = "presenterm-nvim";
  # INFO: Add the presenterm CLI to PATH by default. Overridable via
  # `dependencies.presenterm.package`.
  dependencies = [ "presenterm" ];
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
}
