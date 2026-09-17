{
  lib,
  pkgs,
  ...
}:
let
  handledLanguages = [
    "julia"
    "python"
    "r"
  ];
in
{
  _module.args.handledLanguages = handledLanguages;

  imports = [
    ./_jupytext.nix
    ./_render-markdown.nix
  ];
  programs.nixvim = {
    extraPackages = [ pkgs.quarto ];
    plugins = {
      quarto = {
        enable = true;
        lazyLoad.settings.ft = [ "quarto" ];
        settings = {
          lspFeatures.languages = handledLanguages;
          codeRunner.default_method = "slime";
        };
      };

      # REPL and terminal windows
      vim-slime = {
        enable = lib.mkDefault true;
        lazyLoad.settings.ft = [ "quarto" ];
      };
      snacks = {
        enable = lib.mkDefault true;
        settings.terminal.enable = lib.mkDefault true;
      };

      conform-nvim.settings.formatters_by_ft.quarto = [ "deno_fmt" ];
      lint = {
        lintersByFt.quarto = [ "markdownlint" ];
        linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
      };
      lsp.servers.marksman.filetypes = [ "quarto" ];
    };
    files."ftplugin/quarto.lua".extraConfigLua = ''
      vim.b.slime_cell_delimeter = "```"
    '';
  };
}
