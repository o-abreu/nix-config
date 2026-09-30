{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins;

  mkBlinkPlugin =
    {
      enable ? true,
      ...
    }@args:
    { inherit enable; } // (removeAttrs args [ "enable" ]);
in
{
  programs.nixvim = {
    extraPackages = [
      pkgs.gh
      pkgs.glab
    ];
    plugins = {
      blink-cmp-git = mkBlinkPlugin { };
      blink-cmp-spell = mkBlinkPlugin { };
      blink-emoji = mkBlinkPlugin { };
      blink-ripgrep = mkBlinkPlugin { };

      blink-cmp = {
        extraSources = {
          default = [
            "emoji"
            "spell"
            "ripgrep"
            "spell"
          ];
          gitcommit = [
            "spell"
            "git"
          ];
        };

        settings.sources.providers = {
          emoji = lib.mkIf cfg.blink-emoji.enable {
            name = "Emoji";
            module = "blink-emoji";
            score_offset = 0;
          };

          spell = lib.mkIf cfg.blink-cmp-spell.enable {
            name = "Spell";
            module = "blink-cmp-spell";
            min_keyword_length = 5;
            max_items = 3;
            score_offset = -10;
          };

          ripgrep = lib.mkIf cfg.blink-ripgrep.enable {
            name = "Ripgrep";
            module = "blink-ripgrep";
            async = true;
            timeout_ms = 500;
            max_items = 10;
            min_keyword_length = 4;
            score_offset = 5;
          };

          git = lib.mkIf cfg.blink-cmp-git.enable {
            name = "Git";
            module = "blink-cmp-git";
            enabled = true;
            score_offset = 70;
            should_show_items.__raw =
              # lua
              ''
                function()
                  return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                end
              '';
            opts.git_centers.github.issue.on_error.__raw = "function(_,_) return true end";
          };
        };
      };
    };
  };
}
