-- INFO: Hide the text cursor on the Alpha dashboard, restoring it afterwards.
--
-- WHY NOT `setlocal guicursor=`? In terminal nvim `guicursor` is a *global*
-- option: `nvim_get_option_value("guicursor", {buf = n})` errors with `'buf'
-- cannot be passed for global option`. Setting it on the alpha buffer therefore
-- also changes the global value, and it never comes back after leaving the
-- dashboard. This module saves the global value, applies the hidden cursor, and
-- restores the saved value when the alpha buffer goes away.
--
-- HOW the cursor is hidden: `guicursor = ""` only resets the *shape* to the
-- terminal default (block) in the TUI; it does not make the caret invisible.
-- Instead we point the cursor at a highlight group whose background equals the
-- dashboard's `Normal` background (so a solid caret disappears in any terminal)
-- and also set `blend = 100` (transparent in terminals that support cursor
-- alpha, e.g. WezTerm).
local M = {}

local HIDE_HL = "AlphaCursorHidden"
local SAVED_VAR = "alpha_saved_guicursor"

local function save_guicursor()
  if vim.g[SAVED_VAR] == nil then
    vim.g[SAVED_VAR] = vim.o.guicursor
  end
end

--- Hide the text cursor (global, since `guicursor` is global).
function M.hide()
  save_guicursor()
  -- Idempotent: nothing to do if we're already hidden.
  if vim.o.guicursor:find(HIDE_HL, 1, true) then
    return
  end
  local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  vim.api.nvim_set_hl(0, HIDE_HL, { bg = normal_bg, blend = 100 })
  -- Apply the hidden cursor to all modes (`a:`) so insert mode etc. are hidden too.
  vim.opt.guicursor:append("a:" .. HIDE_HL .. "/lCursor")
end

--- Restore the previously saved global `guicursor`.
function M.restore()
  if vim.g[SAVED_VAR] ~= nil then
    vim.opt.guicursor = vim.g[SAVED_VAR]
    vim.g[SAVED_VAR] = nil
  end
end

return M