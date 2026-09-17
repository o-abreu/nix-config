if not vim.g.whitespace_character_enabled then
  vim.opt.listchars = { eol = "¬", tab = ">→", trail = "~", space = "·" }
  vim.opt.list = true
else
  vim.opt.list = false
end
vim.g.whitespace_character_enabled = not vim.g.whitespace_character_enabled
vim.notify("Whitespace visibility: " .. tostring(vim.g.whitespace_character_enabled))
