-- Lock the Alpha dashboard down: keep only the keymaps that back the
-- dashboard's own buttons, and neutralize everything else.
--
-- Alpha installs the button keymaps *after* firing `AlphaReady`
-- (`alpha.lua`: keymaps at 745, AlphaReady at 744), so callers must run this
-- deferred (e.g. via `vim.schedule`) to see them.
--
-- The whitelist is derived from the buttons themselves, so adding or removing
-- a `dashboard.button(...)` needs no change here.
local M = {}

---@param buf integer
function M.lock(buf)
  local conf = require("alpha").default_config
  if not conf or conf.opts == nil then
    return
  end

  local norm = function(keys)
    return vim.api.nvim_replace_termcodes(keys, true, false, true)
  end

  -- Whitelist the button lhs values. Alpha transforms the displayed shortcut
  -- (e.g. "SPC f w") into the actual key (e.g. "<leader>fw").
  local allowed = {}
  local function collect(el)
    if type(el) ~= "table" then
      return
    end
    if el.type == "button" and el.opts and el.opts.keymap then
      allowed[norm(el.opts.keymap[2])] = true
    elseif el.type == "group" and el.val then
      for _, v in ipairs(el.val) do
        collect(v)
      end
    end
  end
  for _, el in ipairs(conf.layout or {}) do
    collect(el)
  end

  -- Keep alpha's own press/queue keys. Alpha stores each as a string, or a
  -- list of strings.
  local km = conf.opts.keymap or {}
  local function mark_keys(v)
    if type(v) == "string" then
      allowed[norm(v)] = true
    elseif type(v) == "table" then
      for _, k in ipairs(v) do
        allowed[norm(k)] = true
      end
    end
  end
  mark_keys(km.press or { "<CR>" })
  mark_keys(km.queue_press or { "<M-CR>" })

  -- 1. Drop buffer-local maps that aren't whitelisted.
  for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
    if not allowed[m.lhs] then
      pcall(vim.keymap.del, "n", m.lhs, { buffer = buf })
    end
  end

  -- 2. Shadow global maps so they can't fire on the dashboard.
  for _, m in ipairs(vim.api.nvim_get_keymap("n")) do
    if not allowed[m.lhs] then
      vim.keymap.set("n", m.lhs, "<Nop>", { buffer = buf, silent = true })
    end
  end
end

return M
