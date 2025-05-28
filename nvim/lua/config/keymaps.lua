vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
  print("Last reloaded " .. os.clock())
end)
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("x", "p", [["_dP]])                 -- Puts without filling "" register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Yanks into "+ register
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<c-f>", "<cmd>silent !tmux neww tmod<cr>")
vim.keymap.set("n", "<c-g>", "<cmd>silent !tmux neww tmcd<cr>")
vim.keymap.set("t", "<c-w>j", "<c-\\><c-n><c-w>j")
vim.keymap.set("t", "<c-w>k", "<c-\\><c-n><c-w>k")
vim.keymap.set("t", "<c-w>h", "<c-\\><c-n><c-w>h")
vim.keymap.set("t", "<c-w>l", "<c-\\><c-n><c-w>l")
vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)
