local M = {}

local function venv_cmd()
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    local ipython = venv .. "/bin/ipython"
    if vim.fn.executable(ipython) == 1 then
      return ipython .. " --no-confirm-exit --no-autoindent"
    end
    local python = venv .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
  if vim.fn.executable("ipython") == 1 then
    return "ipython --no-confirm-exit --no-autoindent"
  end
  if vim.fn.executable("python") == 1 then
    return "python"
  end
  return nil
end

M.langs = {
  python = { count = 4, cmd = venv_cmd },
  julia = { count = 5, cmd = function() return "julia" end },
  r = { count = 6, cmd = function() return "R --no-save" end },
}

function M.for_lang(lang)
  local spec = M.langs[lang]
  if not spec then
    vim.notify("REPL: unsupported language '" .. tostring(lang) .. "'", vim.log.levels.WARN)
    return nil
  end
  local cmd = spec.cmd()
  if not cmd then
    vim.notify("REPL: no interpreter found for " .. lang, vim.log.levels.WARN)
    return nil
  end
  return { cmd = cmd, count = spec.count }
end

function M.for_current()
  local ok, keeper = pcall(require, "otter.keeper")
  if not ok then
    vim.notify("REPL: otter not available", vim.log.levels.WARN)
    return nil
  end
  local lang = keeper.get_current_language_context()
  if not lang then
    vim.notify("REPL: cursor is not inside a code block", vim.log.levels.WARN)
    return nil
  end
  return M.for_lang(lang)
end

return M
