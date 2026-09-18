local M = {}

-- State of the last action registered through M.run()
local S = { fn = nil, count = 1, opts = {}, fresh = false }

--- True while the action is being replayed by `.` (as opposed to the first press).
function M.repeating()
  return not S.fresh
end

--- Shared 'operatorfunc'. Invoked by `g@l` on the first run *and* on every `.`.
---@param _motion "char"|"line"|"block"
function M.opfunc(_motion)
  local fn = S.fn
  if not fn then
    return
  end

  -- A count typed before `.` wins (`3.`); otherwise reuse the original count.
  local count = vim.v.count > 0 and vim.v.count or S.count
  S.count = count

  for i = 1, count do
    if i > 1 and S.opts.undojoin ~= false then
      pcall(vim.cmd, "undojoin") -- collapse the N iterations into one undo block
    end
    local ok, err = pcall(fn, i, count)
    if not ok then
      vim.notify("dot-repeat: " .. tostring(err), vim.log.levels.ERROR)
      break
    end
  end

  S.fresh = false -- everything from here on is a `.` replay
end

--- Execute `fn` now, count-aware, and make `.` / `N.` replay it.
---@param fn fun(i: integer, count: integer)
---@param opts? { undojoin?: boolean }
function M.run(fn, opts)
  S.fn, S.count, S.opts, S.fresh = fn, vim.v.count1, opts or {}, true
  vim.o.operatorfunc = [[v:lua.require'util.dot'.opfunc]]
  vim.api.nvim_feedkeys("g@l", "n", false)
end

--- Wrap a function *or an Ex command string* into a repeatable callback.
---@param action string|fun(i: integer, count: integer)
---@param opts? { undojoin?: boolean }
function M.wrap(action, opts)
  local fn = type(action) == "string" and function()
    vim.cmd(action)
  end or action
  return function()
    M.run(fn, opts)
  end
end

--- keymap.set + wrap in one call.
function M.map(mode, lhs, action, desc, opts)
  vim.keymap.set(mode, lhs, M.wrap(action, opts), {
    silent = true,
    noremap = true,
    desc = desc,
  })
end

return M
