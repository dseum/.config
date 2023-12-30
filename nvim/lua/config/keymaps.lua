vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")

-- Block move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cursor position invariance
vim.keymap.set("n", "J", "mzJ`z")

-- Cursor position centering
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Nvim register invariance
vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Yank to system register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- No recording
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "Q", "<nop>")

-- Project switching
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmod<CR>")

-- Search current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Source
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
    print("last reloaded " .. os.clock())
end)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- function get_bufs_loaded()

-- 	local bufs_loaded = {}
--
-- 	for i, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
-- 		if vim.api.nvim_buf_is_loaded(buf_hndl) then
-- 			bufs_loaded[i] = buf_hndl
-- 		end
-- 	end
--
-- 	return #bufs_loaded
-- end
--
-- function get_buf_test(options)
-- 	local buffers = {}
-- 	local len = 0
-- 	local options_listed = options.listed
-- 	local vim_fn = vim.fn
-- 	local buflisted = vim_fn.buflisted
--
-- 	for buffer = 1, vim_fn.bufnr("$") do
-- 		if not options_listed or buflisted(buffer) ~= 1 then
-- 			len = len + 1
-- 			buffers[len] = buffer
-- 		end
-- 	end
--
-- 	return dump(buffers)
-- end
--
-- local group = vim.api.nvim_create_augroup("BufDeleteToEx", { clear = true })
-- vim.keymap.set("n", "<leader>ho", function()
-- 	print(get_buf_test({
-- 		listed = false,
-- 	}))
-- end)
-- vim.api.nvim_create_autocmd("BufDelete", {
-- 	callback = function()
-- 		if get_bufs_loaded() < 3 then
-- 			vim.cmd.Ex()
-- 		end
-- 	end,
-- 	group = group,
-- })
