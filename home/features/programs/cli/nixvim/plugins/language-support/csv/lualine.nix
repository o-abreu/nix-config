{
  programs.nixvim.plugins.lualine.settings.sections.lualine_x = [
    {
      __unkeyed-1.__raw = ''
        function()
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.bo[buf].filetype
          local name = vim.api.nvim_buf_get_name(buf):lower()
          local is_tsv = ft == "tsv" or name:match("%.tsv$") ~= nil
          if not (ft == "csv" or is_tsv or name:match("%.csv$")) then
            return ""
          end

          -- csvview has async, quote-aware metrics; prefer them when the
          -- plugin managed to attach (normal-sized files).
          local ok, view = pcall(function()
            return require("csvview.view").get(buf)
          end)
          if ok and view then
            local ok_metrics, rows, cols = pcall(function()
              local metrics = view.metrics
              return metrics:row_count_logical(), metrics:column_count()
            end)
            if ok_metrics and rows then
              return string.format("%d rows × %d cols", rows, cols)
            end
          end

          -- INFO: faster.nvim may clear `&filetype` for large files, and
          -- csvview only attaches once its async parse finishes, so a view may
          -- be missing even for CSV buffers. Fall back to counting the buffer:
          -- rows are physical lines (O(1)) and columns come from scanning the
          -- first non-comment line, ignoring delimiters inside quotes.
          local line_count = vim.api.nvim_buf_line_count(buf)
          local header
          for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, math.min(line_count, 20), false)) do
            if line ~= "" and not line:match("^#") and not line:match("^//") then
              header = line
              break
            end
          end
          if not header then
            return ""
          end

          local delimiters = is_tsv and { "\t" } or { ",", "\t", ";", "|" }
          local best_count = 0
          for _, delim in ipairs(delimiters) do
            local count, quoted, i = 0, false, 1
            while i <= #header do
              local char = header:sub(i, i)
              if char == '"' then
                if quoted and header:sub(i + 1, i + 1) == '"' then
                  i = i + 1
                else
                  quoted = not quoted
                end
              elseif not quoted and char == delim then
                count = count + 1
              end
              i = i + 1
            end
            if count > best_count then
              best_count = count
            end
          end

          return string.format("%d rows × %d cols", line_count, best_count + 1)
        end
      '';
    }
  ];
}
