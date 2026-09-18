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
    "<localleader>p",
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

  nmap(bind "n", dot.wrap "Presenterm new", "New slide after current")
  nmap(bind "N", new_slide_before, "New slide before current")
  nmap(bind "s", cmd "split", "Split slide")
  nmap(bind "d", cmd "delete", "Delete slide")
  nmap(bind "y", cmd "yank", "Yank slide")
  nmap(bind "v", cmd "select", "Select slide")
  nmap(bind "k", dot.wrap "Presenterm move-down", "Move slide down")
  nmap(bind "l", dot.wrap "Presenterm move-up", "Move slide up")
  nmap(bind "R", cmd "reorder", "Reorder slides")
  nmap(bind "L", cmd "list", "List slides")
  nmap(bind "c", cmd "layout", "Select column layout")
  nmap(bind "pi", cmd "partial include", "Include partial file")
  nmap(bind "pe", cmd "partial edit", "Edit partial file")
  nmap(bind "pl", cmd "partial list", "List all partials")
end
