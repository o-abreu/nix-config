{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim =
      let
        cfg = config.programs.nixvim.plugins.vim-slime;
        prefix = "<leader>R";
        # function to detect if slime cells are configured or fail nicely.
        sendCell = plug: {
          __raw =
            # lua
            ''
              function()
                if vim.g.slime_cell_delimiter or vim.b.slime_cell_delimiter then
                  return "<Plug>${plug}"
                else
                  return "<cmd>lua vim.notify('No slime cell configured')<CR>"
                end
              end
            '';
        };
      in
      {
        plugins = {
          which-key.settings.spec = [
            {
              __unkeyed-1 = prefix;
              mode = [
                "n"
                "x"
              ];
              group = "REPL";
              icon = "⚡";
            }
          ];

          vim-slime = {
            settings.no_mappings = 1;
            lazyLoad.settings.keys =
              [
                {
                  __unkeyed-1 = prefix + "r";
                  __unkeyed-2 = "<Plug>SlimeMotionSend";
                  mode = [
                    "n"
                    "x"
                    "o"
                  ];
                  desc = "Send motion";
                }

                {
                  __unkeyed-1 = prefix + "c";
                  __unkeyed-2 = sendCell "SlimeSendCell";
                  expr = true;
                  desc = "Send cell";
                }

                {
                  __unkeyed-1 = prefix + "p";
                  __unkeyed-2 = "<Plug>SlimeParagraphSend";
                  desc = "Send paragraph";
                }

                {
                  __unkeyed-1 = prefix + "l";
                  __unkeyed-2 = "<Plug>SlimeLineSend";
                  desc = "Send line";
                }

                {
                  __unkeyed-1 = prefix + "<cr>";
                  __unkeyed-2 = "<Cmd>SlimeConfig<cr>";
                  desc = "Config";
                }

                {
                  __unkeyed-1 = prefix + "r";
                  __unkeyed-2 = "<Plug>SlimeRegionSend";
                  mode = "x";
                  desc = "Send region";
                }
              ]
              |> map (
                m:
                m
                // {
                  mode = m.mode or "n";
                  remap = true;
                  silent = true;
                }
              )
              |> lib.optionals cfg.enable;
          };
        };

        plugins.lz-n.plugins = [
          {
            __unkeyed-1 = "vim-slime-cells";
            before.__raw = ''
              function()
                require("lz.n").trigger_load("vim-slime")
              end
            '';
            keys =
              [
                {
                  __unkeyed-1 = "[c";
                  __unkeyed-2 = "<Plug>SlimeCellsPrev";
                  desc = "Previous cell";
                }

                {
                  __unkeyed-1 = "]c";
                  __unkeyed-2 = "<Plug>SlimeCellsNext";
                  desc = "Next cell";
                }

                {
                  __unkeyed-1 = prefix + "C";
                  __unkeyed-2 = sendCell "SlimeCellsSendAndGoToNext";
                  expr = true;
                  desc = "Send cell and go to next";
                }
              ]
              |> map (
                m:
                m
                // {
                  mode = m.mode or "n";
                  remap = true;
                  silent = true;
                }
              );
          }
        ];
        keymaps = [
          {
            key = prefix + "m";
            action.__raw = ''
              function()
                local job_id = vim.b.terminal_job_id
                if job_id then
                  vim.notify("slime terminal jobid: " .. job_id)
                else
                  vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
                end
              end
            '';
            mode = "n";
            options.desc = "Mark terminal (show jobid)";
          }
        ];
      };
  };
}
