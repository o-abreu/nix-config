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
    };
  names = [
    "vim-slime-cells"
    "alpha-ascii.nvim"
    "presenterm.nvim"
    "qalc.nvim"
    "sshfs.nvim"
  ];
in
{
  vimPlugins = prev.vimPlugins // lib.listToAttrs (
    map (name: lib.nameValuePair (toInput name) (buildPlugin name)) names
  );
}
