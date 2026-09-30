-- INFO: Two-column dashboard layout for alpha.
--
-- alpha has no native column/horizontal element: every layout element is
-- appended as whole lines on a single vertical stack. This module provides a
-- custom `dash_two_column` element that renders a flat list of shortcut cells
-- evenly split across two columns.
--
-- Usage (from the dashboard config):
--
--   local two_col = require("alpha.layout.two-col")
--   local element = two_col.columns(cells, { gap = 6, width = 34 })
--   dashboard.config.layout = { padding, header, padding, element, footer }
--
-- `M.columns` registers the `layout_element` / `keymaps_element` handlers on
-- first use, so importing it once is enough.
local M = {}
local alpha = require("alpha")

local function pad(n)
  return string.rep(" ", math.max(0, n))
end

--- Render a single cell to its display text and shortcut highlight byte range.
---@param cell any
---@return string text, string? hl_group, integer start_col, integer end_col
local function cell_text(cell)
  if type(cell) ~= "table" then
    return "", nil, 0, 0
  end
  local opts = cell.opts or {}
  local label = cell.val or ""
  local shortcut = opts.shortcut or ""
  local width = opts.width or 34
  local fill = math.max(1, width - vim.fn.strdisplaywidth(label) - vim.fn.strdisplaywidth(shortcut))
  local text = label .. pad(fill) .. shortcut
  -- nvim_buf_add_highlight uses BYTE columns.
  local hl_start = #label + fill
  return text, opts.hl_shortcut, hl_start, hl_start + #shortcut
end

local installed = false

-- INFO: Register `alpha.layout_element.dash_two_column` and its keymaps
-- counterpart. alpha's `keymaps()` dispatches by element type, so without the
-- second handler it errors on startup.
local function install()
  if installed then
    return
  end
  installed = true

  alpha.layout_element.dash_two_column = function(el, conf, state)
    local gap = (el.opts and el.opts.gap) or 6
    local start_line = state.line

    -- Split the flat cell list evenly across two columns.
    local cells = el.val or {}
    local half = math.ceil(#cells / 2)
    local col1, col2 = {}, {}
    for i = 1, #cells do
      if i <= half then
        col1[#col1 + 1] = cells[i]
      else
        col2[#col2 + 1] = cells[i]
      end
    end

    local rows = {}
    local highlights = {}
    for i = 1, half do
      local left_text, left_hl, left_start, left_end = cell_text(col1[i])
      local right_text, right_hl, right_start, right_end = cell_text(col2[i])
      local line = left_text
      if col2[i] then
        line = line .. pad(gap) .. right_text
      end
      rows[i] = line
      if col1[i] and left_hl then
        highlights[#highlights + 1] = { i, left_hl, left_start, left_end }
      end
      if col2[i] and right_hl then
        local offset = #left_text + gap -- byte offset (icons are multibyte)
        highlights[#highlights + 1] = { i, right_hl, offset + right_start, offset + right_end }
      end
    end

    local centered, left = alpha.align_center(rows, state)
    local hl = {}
    for _, h in ipairs(highlights) do
      hl[#hl + 1] = {
        state.buffer,
        -1,
        h[2],
        start_line + h[1] - 1,
        left + h[3],
        left + h[4],
      }
    end
    state.line = start_line + #rows
    return centered, hl
  end

  alpha.keymaps_element.dash_two_column = function(el, conf, state)
    for _, cell in ipairs(el.val or {}) do
      if type(cell) == "table" then
        alpha.keymaps_element.button(cell, conf, state)
      end
    end
  end
end

--- Build a `dash_two_column` layout element from a flat list of cells.
---@param cells table[] list of `dashboard.button(...)` objects
---@param opts? { gap?: integer, width?: integer }
---@return table
function M.columns(cells, opts)
  opts = opts or {}
  install()
  local gap = opts.gap or 6
  local width = opts.width or 34
  for _, cell in ipairs(cells) do
    if type(cell) == "table" then
      cell.opts = cell.opts or {}
      cell.opts.width = width
    end
  end
  return { type = "dash_two_column", val = cells, opts = { gap = gap } }
end

return M