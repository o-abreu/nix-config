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

  -- INFO: Slide keys live on the bare `,` namespace (the letters markdown-plus
  -- leaves free: `,l` is Lists, `,L` is Links, `,c` is code block insert, `,p`
  -- is markdown preview). Move down/up use vim's j/k semantics instead of the
  -- plugin's inverted k/l defaults.
  -- INFO: `nmap` prepends `<localleader>` itself, so keys are passed raw here.
  nmap("n", dot.wrap "Presenterm new", "New slide after current")
  nmap("N", new_slide_before, "New slide before current")
  nmap("s", cmd "split", "Split slide")
  nmap("d", cmd "delete", "Delete slide")
  nmap("y", cmd "yank", "Yank slide")
  nmap("v", cmd "select", "Select slide")
  nmap("j", dot.wrap "Presenterm move-down", "Move slide down")
  nmap("k", dot.wrap "Presenterm move-up", "Move slide up")
  nmap("R", cmd "reorder", "Reorder slides")
  nmap("O", cmd "list", "Outline")
  nmap("A", cmd "layout", "Arrange column layout")

  -- INFO: In-editor live preview in a terminal vsplit (spawns a fresh split
  -- each time, close the terminal buffer to dismiss) and the buffer <->
  -- preview slide sync switch.
  nmap("V", cmd "preview", "Spawn presenterm preview")
  nmap("Y", cmd "toggle-sync", "Toggle preview sync")

  -- INFO: `,P` stays a group, but as "Partials" (lowercase `,p` is markdown
  -- preview; uppercase `,P` is free in markdown buffers).
  nmap("Pi", cmd "partial include", "Include partial file")
  nmap("Pe", cmd "partial edit", "Edit partial file")
  nmap("Pl", cmd "partial list", "List all partials")
end
