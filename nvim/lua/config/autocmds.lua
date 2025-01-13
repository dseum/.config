vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd.startinsert()
    end
  end,
})
local non_filetypes = { "oil" }
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local value
    if
      vim.bo.buftype == ""
      and not vim.list_contains(non_filetypes, vim.bo.filetype)
    then
      value = "80"
    else
      value = ""
    end
    vim.wo.colorcolumn = value
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})
