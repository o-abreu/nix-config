# INFO: presenterm.nvim — author and run presenterm presentations from Neovim.

{ lib, ... }:
{
  imports = [
    # INFO: Declare the `dependencies.presenterm.*` options. Nixvim has no
    # built-in `presenterm` dependency, so the default package is registered
    # here.
    { __depPackages.presenterm.default = "presenterm"; }

    (import ./_options.nix { inherit lib; })

  ];

  # INFO: Configuring `settings` makes nixvim default `lazyLoad.enable` to
  # true. presenterm registers its auto-activation FileType autocmd inside
  # `plugin/presenterm.lua`, which cannot fire for the buffer that triggers
  # the load, so the plugin must be eager.
  plugins.presenterm.lazyLoad.enable = lib.mkDefault false;
}
