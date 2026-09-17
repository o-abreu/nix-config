local curr_foldcolumn = vim.wo.foldcolumn
if curr_foldcolumn ~= "0" then
  vim.g.last_active_foldcolumn = curr_foldcolumn
end
vim.wo.foldcolumn = curr_foldcolumn == "0" and (vim.g.last_active_foldcolumn or "1") or "0"
vim.notify(string.format("Fold Column %s", tostring(vim.wo.foldcolumn), "info"))
