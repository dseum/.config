vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("i", "jj", "<Esc>")

-- Source
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
  print("Last reloaded " .. os.clock())
end)

-- Cursor position
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")

-- Put without filling `quotequote` register
vim.keymap.set("x", "p", [["_dP]])

-- Yank into `quoteplus` register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Disable recording
vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "Q", "<Nop>")

-- Management
vim.keymap.set("n", "<c-f>", "<cmd>silent !tmux neww tmod<cr>")
-- vim.keymap.set("n", "<c-c>", "<cmd>silent !tmux neww tmcd<cr>")

-- Terminal
vim.keymap.set("t", "<c-w>j", "<c-\\><c-n><c-w>j")
vim.keymap.set("t", "<c-w>k", "<c-\\><c-n><c-w>k")
vim.keymap.set("t", "<c-w>h", "<c-\\><c-n><c-w>h")
vim.keymap.set("t", "<c-w>l", "<c-\\><c-n><c-w>l")
