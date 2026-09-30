local nav = require "markdown-plus.table.navigation"

local arrows = {
  left = "<Left>",
  down = "<Down>",
  up = "<Up>",
  right = "<Right>",
}

local M = {}

-- INFO: Try the markdown-plus cell move first (it returns true when
-- the cursor is inside a table). Outside a table, defer to
-- smart-splits' insert-mode resize on <A-j/k/l/;>, or feed the plain
-- arrow key when smart-splits is unavailable.
local function fallback(dir)
  local ok, ss = pcall(require, "smart-splits")
  if ok then
    ss["resize_" .. dir]()
    return
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(arrows[dir], true, false, true), "n", false)
end

local function make(dir)
  return function()
    if nav["move_" .. dir]() then
      return
    end
    fallback(dir)
  end
end

M.left = make "left"
M.down = make "down"
M.up = make "up"
M.right = make "right"

return M
