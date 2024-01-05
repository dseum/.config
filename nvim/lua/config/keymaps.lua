vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")

-- Cursor position
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Put without filling `quotequote` register
vim.keymap.set("x", "p", [["_dP]])

-- Yank into `quoteplus` register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Disable recording
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "Q", "<nop>")

-- Find project
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmod<CR>")

-- Source
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
  print("Last reloaded " .. os.clock())
end)
