{
  config,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    blink-cmp-git.enable = true;

    blink-cmp = {
      extraSources.gitcommit = [ "git" ];

      settings.sources.providers.git =
        lib.mkIf config.programs.nixvim.plugins.blink-cmp-git.enable {
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
}
