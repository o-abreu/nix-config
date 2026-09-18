# INFO: Portable nixvim modules authored for this flake.
#
# Each entry is a nixvim module (declares `options.plugins.<name>.*` via
# `lib.nixvim.plugins.mkNeovimPlugin`). Plugins are disabled by default, like
# any nixvim plugin; consumers opt in explicitly. Import them into
# `programs.nixvim.imports` under Home Manager, or into the top-level `imports`
# of a standalone nixvim configuration.
#
# Consumed through `outputs.nixvimModules`.
#
# Adding a plugin:
#   1. Expose its package via `overlays/vim-plugins.nix` (or nixpkgs).
#   2. Add the module definition in this directory.
#   3. List it below.
{ ... }: { presenterm-nvim = import ./presenterm-nvim.nix; }
