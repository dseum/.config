vim.opt.guicursor = "a:block"

-- Better
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.showcmd = false
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true

-- Lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
