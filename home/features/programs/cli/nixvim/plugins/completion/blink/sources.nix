{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.blink-cmp;
  extra = cfg.extraSources;
  toLua = lib.generators.toLua { };

  # Built-in sources are always available; feature modules contribute the rest
  # through `plugins.blink-cmp.extraSources`.
  baseSources = [
    "buffer"
    "lsp"
    "path"
    "snippets"
  ];
  defaultSources = baseSources ++ extra.default;
  commentSources = [ "buffer" ] ++ extra.comment;
  gitcommitSources = [ "buffer" ] ++ extra.gitcommit;
in
{
  programs.nixvim.plugins.blink-cmp.settings.sources = {
    # The only genuinely dynamic part is the Treesitter comment context; the
    # source lists themselves are declared by the feature modules.
    default.__raw =
      # lua
      ''
        function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return ${toLua commentSources}
          elseif vim.bo.filetype == 'gitcommit' then
            return ${toLua gitcommitSources}
          end
          return ${toLua defaultSources}
        end
      '';

    providers = {
      # BUILT-IN SOURCES
      buffer = {
        score_offset = 45;
        min_keyword_length = 2;
        max_items = 15;
        opts = {
          # Allow searching all open buffers or just current.
          get_bufnrs.__raw =
            # lua
            ''
              function()
                if vim.g.blink_buffer_all_buffers == nil then vim.g.blink_buffer_all_buffers = true end

                if vim.g.blink_buffer_all_buffers then
                  return vim.tbl_filter(function(bufnr)
                    return vim.bo[bufnr].buftype == ""
                  end, vim.api.nvim_list_bufs())
                else
                  return { vim.api.nvim_get_current_buf() }
                end
              end
            '';
        };
      };

      lsp = {
        score_offset = 80;
        fallbacks = [ ]; # Allow buffer to show independently
        transform_items.__raw =
          # lua
          ''
            function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
              end, items)
            end
          '';
      };

      path = {
        score_offset = 55;
      };

      snippets = {
        score_offset = 60;
        should_show_items.__raw =
          # lua
          ''
            function(ctx)
              return ctx.trigger.initial_kind ~= 'trigger_character'
            end
          '';
      };
    };
  };
}
