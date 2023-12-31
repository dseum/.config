vim.keymap.set("n", "K", function()
  local old_isk = vim.bo.iskeyword
  vim.bo.iskeyword = vim.bo.iskeyword .. ",:"
  local str = vim.fn.expand("<cword>")
  vim.bo.iskeyword = old_isk
  print(str)
  vim.cmd("Man " .. str)
end, { desc = "Hover Documentation" })
