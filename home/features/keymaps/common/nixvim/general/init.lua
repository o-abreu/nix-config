local col = vim.fn.col "." - 1
if col == 0 then
  return
end

local line = vim.fn.getline "."
local left_text = line:sub(1, col)
local spaces = left_text:match "(%s+)$"

if spaces then
  local row = vim.fn.line "." - 1
  vim.api.nvim_buf_set_text(0, row, col - #spaces, row, col, { "" })
end
