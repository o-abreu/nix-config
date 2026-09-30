{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
in
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nix-unit
      namaka
    ];
    extraPlugins = with pkgs.vimPlugins; [
      neotest-nix
    ];
    plugins = {
      lsp.servers.statix.enable = true;

      conform-nvim.settings = {
        formatters_by_ft.nix = [ "alejandra" ];
        formatters.nixfmt.command = getExe pkgs.nixfmt;
      };

      lint = {
        enable = true;
        lintersByFt.nix = [ "deadnix" ];
        linters.deadnix.cmd = getExe pkgs.deadnix;
      };

      neotest.settings.adapters = [
        "require('neotest-nix')"
      ];

      direnv.enable = pkgs.stdenv.hostPlatform.isLinux;
      nix-develop.enable = true;
    };
  };
}
