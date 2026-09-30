function(bufnr)
  local dot = require "util.dot"
  local wk = require "which-key"

  local bind = function(key)
    return "<localleader>" .. key
  end

  local nmap = function(key, action, desc)
    vim.keymap.set("n", bind(key), action, {
      buffer = bufnr,
      silent = true,
      noremap = true,
      desc = desc,
    })
  end

  wk.add {
    "<localleader>P",
    group = "Partials",
    icon = "",
    bufnr = bufnr,
    mode = "n",
  }

  local cmd = function(action)
    return "<cmd>Presenterm " .. action .. "<cr>"
  end

  -- INFO: Create an empty slide before the current one.
  -- `:Presenterm new` only inserts after the current slide (and mishandles the
  -- last slide), so insert the marker block directly at the current slide's top
  -- boundary instead of chaining new + move-up.
  local new_slide_before = function()
    local slides = require "presenterm.slides"
    local cfg = require("presenterm.config").get()

    local current, positions = slides.get_current_slide()
    local start_line = positions[current] + 1

    vim.fn.append(start_line - 1, { "", "", cfg.slide_marker })
    vim.fn.cursor(start_line + 1, 1)
    vim.cmd "startinsert"
  end

  -- INFO: All presenterm keys live under the `,P` prefix instead of the bare
  -- `,` (which markdown-plus now owns for formatting/lists/code). The `,p`
  -- leaf was also let go: markdown-plus uses it for Smart Paste.
  nmap(bind "Pn", dot.wrap "Presenterm new", "New slide after current")
  nmap(bind "PN", new_slide_before, "New slide before current")
  nmap(bind "Ps", cmd "split", "Split slide")
  nmap(bind "Pd", cmd "delete", "Delete slide")
  nmap(bind "Py", cmd "yank", "Yank slide")
  nmap(bind "Pv", cmd "select", "Select slide")
  nmap(bind "Pk", dot.wrap "Presenterm move-down", "Move slide down")
  nmap(bind "Pl", dot.wrap "Presenterm move-up", "Move slide up")
  nmap(bind "PR", cmd "reorder", "Reorder slides")
  nmap(bind "PL", cmd "list", "List slides")
  nmap(bind "Pc", cmd "layout", "Select column layout")
  nmap(bind "PPi", cmd "partial include", "Include partial file")
  nmap(bind "PPe", cmd "partial edit", "Edit partial file")
  nmap(bind "PPl", cmd "partial list", "List all partials")
end
