# INFO: Nixvim plugins built from non-flake GitHub inputs.
#
# Inputs are declared with `flake = false` in flake.nix. Each entry is the
# upstream plugin name (dots allowed); it is exposed for nixvim as
# `pkgs.vimPlugins.<name-with-dashes>` instead of every module rebuilding it
# with `pkgs.vimUtils.buildVimPlugin`.
#
# Adding a plugin: declare the input in flake.nix, then add its name here.
{ inputs, lib, ... }:
_final: prev:
let
  toInput = name: lib.strings.replaceStrings [ "." ] [ "-" ] name;
  buildPlugin =
    name:
    prev.vimUtils.buildVimPlugin {
      pname = name;
      version = "main";
      src = inputs.${toInput name};
      # INFO: `snacks_zotero.database` requires `sqlite.db` from
      # kkharji/sqlite.lua, and the picker uses folke/snacks.nvim. Declaring the
      # dependencies lets nixpkgs' neovimRequireCheckHook put them on the
      # runtimepath during the check, and makes the plugin self-contained.
      dependencies = lib.optionals (name == "snacks-zotero.nvim") [
        prev.vimPlugins.snacks-nvim
        prev.vimPlugins.sqlite-lua
      ];
    };
in
{
  vimPlugins =
    [
      "alpha-ascii.nvim"
      "crazy-coverage.nvim"
      "markdown-plus.nvim"
      "nvim-prose"
      "presenterm.nvim"
      "qalc.nvim"
      "snacks-zotero.nvim"
      "sshfs.nvim"
      "vim-slime-cells"
    ]
    |> map (name: lib.nameValuePair (toInput name) (buildPlugin name))
    |> lib.listToAttrs
    |> (plugins: prev.vimPlugins // plugins);
}
