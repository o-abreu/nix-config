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
        # INFO: `discover_eval_checks` evaluates the flake so checks produced by
        # functions (and therefore invisible in the source) also appear in the
        # summary tree. It is off upstream because it shells out to `nix eval`.
        # `vm_interactive` stays false: VM tests keep the headless streaming
        # strategy, which is what produces the per-line `testScript` diagnostics.
        # `nix`, `nix-unit`, and `namaka` are all already on PATH via
        # `extraPackages` above and the system profile.
        ''
          require('neotest-nix')({
            discover_eval_checks = true,
            vm_interactive = false,
            non_flake_roots = true,
          })
        ''
      ];

      direnv.enable = pkgs.stdenv.hostPlatform.isLinux;
      nix-develop.enable = true;
    };
  };
}
