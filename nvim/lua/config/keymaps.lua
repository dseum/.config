vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")

-- Source
vim.keymap.set("n", "<Leader><Leader>", function()
  vim.cmd("so")
  print("Last reloaded " .. os.clock())
end)

-- Cursor position
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Put without filling `quotequote` register
vim.keymap.set("x", "p", [["_dP]])

-- Yank into `quoteplus` register
vim.keymap.set({ "n", "v" }, "<Leader>y", [["+y]])
vim.keymap.set("n", "<Leader>Y", [["+Y]])

-- Disable recording
vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "Q", "<Nop>")

-- Find project
vim.keymap.set("n", "<C-f>", "<Cmd>silent !tmux neww tmod<CR>")

-- Terminal
-- vim.keymap.set("i", )
