{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkIf (options ? programs.nixvim) {
    programs.nixvim.plugins.gitsigns.settings =
      let
        cfg = config.programs.nixvim.plugins.which-key;
      in
      lib.mkIf cfg.enable {
        on_attach.__raw = # lua
          ''
            function(bufnr)
              local prefix = "<leader>gh"
              local gs = require('gitsigns')
              ${lib.optionalString cfg.enable
                # lua
                ''
                  local wk = require('which-key')

                  wk.add({
                    { prefix, group = "Hunk Actions", icon = " ", buffer = bufnr },
                  })
                ''
              }

              local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
              end

              map('n', ']g', function() gs.nav_hunk('next') end, "Next Git hunk")
              map('n', '[g', function() gs.nav_hunk('prev') end, "Previous Git hunk")
              map('n', ']G', function() gs.nav_hunk('last') end, "Last Git hunk")
              map('n', '[G', function() gs.nav_hunk('first') end, "First Git hunk")

              map('n', prefix .. "l", gs.blame_line, "View Git blame")
              map('n', prefix .. "L", function() gs.blame_line { full = true } end, "View full Git blame")
              map('n', prefix .. "p", gs.preview_hunk_inline, "Preview Git hunk")
              map('n', prefix .. "r", gs.reset_hunk, "Reset Git hunk")
              map('n', prefix .. "R", gs.reset_buffer, "Reset Git buffer")
              map('n', prefix .. "s", gs.stage_hunk, "Stage/Unstage Git hunk")
              map('n', prefix .. "S", gs.stage_buffer, "Stage Git buffer")
              map('n', prefix .. "d", gs.diffthis, "View Git diff")

              map('v', prefix .. "r", function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Reset Git hunk")
              map('v', prefix .. "s", function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Stage Git hunk")

              map({'o', 'x'}, 'ig', ':<C-U>Gitsigns select_hunk<CR>', "inside Git hunk")
            end
          '';
      };
  };
}
