{ bufferline, lib, ... }:
{
  programs.nixvim.keymaps =
    let
      splitWindow = orientation: {
        __raw =
          # lua
          ''
            function()
              local current_id = vim.api.nvim_get_current_buf()
              require("bufferline.pick").choose_then(function(id)
                vim.cmd("${orientation}")
                if id and id ~= current_id then
                  vim.cmd("buffer " .. id)
                end
              end)
            end
          '';
      };
    in
    [
      {
        key = "\\";
        action = splitWindow "vsplit";
        options.desc = "Vertical split";
      }
      {
        key = "-";
        action = splitWindow "split";
        options.desc = "Horizontal split";
      }
    ]
    |> map (m: m // { mode = "n"; })
    |> lib.optionals bufferline.cfg.enable;
}
