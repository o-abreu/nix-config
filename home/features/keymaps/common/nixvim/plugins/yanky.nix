{
  programs.nixvim.plugins.yanky.lazyLoad.settings.keys =
    [
      {
        __unkeyed-1 = "y";
        __unkeyed-2 = "<Plug>(YankyYank)";
        mode = [ "n" "x" ];
        desc = "Yank text";
      }
      {
        __unkeyed-1 = "p";
        __unkeyed-2 = "<Plug>(YankyPutAfter)";
        mode = [ "n" "x" ];
        desc = "Put yanked text after cursor";
      }
      {
        __unkeyed-1 = "P";
        __unkeyed-2 = "<Plug>(YankyPutBefore)";
        mode = [ "n" "x" ];
        desc = "Put yanked text before cursor";
      }
      {
        __unkeyed-1 = "gp";
        __unkeyed-2 = "<Plug>(YankyGPutAfter)";
        mode = [ "n" "x" ];
        desc = "Put yanked text after cursor and leave cursor after";
      }
      {
        __unkeyed-1 = "gP";
        __unkeyed-2 = "<Plug>(YankyGPutBefore)";
        mode = [ "n" "x" ];
        desc = "Put yanked text before cursor and leave cursor after";
      }
      {
        __unkeyed-1 = "gz";
        __unkeyed-2.__raw =
          # lua
          ''
            function()
              local view = vim.fn.winsaveview()
              require("yanky").put("p", false)
              vim.fn.winrestview(view)
            end
          '';
        desc = "Put yanked text after cursor without moving cursor";
      }
      {
        __unkeyed-1 = "gZ";
        __unkeyed-2.__raw =
          # lua
          ''
            function()
              local view = vim.fn.winsaveview()
              require("yanky").put("P", false)
              vim.fn.winrestview(view)
            end
          '';
        desc = "Put yanked text before cursor without moving cursor";
      }
      {
        __unkeyed-1 = "]p";
        __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
        desc = "Put indented after cursor (linewise)";
      }
      {
        __unkeyed-1 = "[p";
        __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
        desc = "Put indented before cursor (linewise)";
      }
      {
        __unkeyed-1 = ">p";
        __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftRight)";
        desc = "Put and indent right";
      }
      {
        __unkeyed-1 = "<p";
        __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftLeft)";
        desc = "Put and indent left";
      }
      {
        __unkeyed-1 = ">P";
        __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftRight)";
        desc = "Put before and indent right";
      }
      {
        __unkeyed-1 = "<P";
        __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftLeft)";
        desc = "Put before and indent left";
      }
      {
        __unkeyed-1 = "=p";
        __unkeyed-2 = "<Plug>(YankyPutAfterFilter)";
        desc = "Put after applying a filter";
      }
      {
        __unkeyed-1 = "=P";
        __unkeyed-2 = "<Plug>(YankyPutBeforeFilter)";
        desc = "Put before applying a filter";
      }
    ]
    |> map (
      m:
      m
      // {
        remap = true;
        silent = true;
        mode = m.mode or "n";
      }
    );
}
