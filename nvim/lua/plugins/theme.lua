return {
	"folke/tokyonight.nvim",
	config = function()
		require("tokyonight").setup({
			on_colors = function() end,
			on_highlights = function(hl, c)
				hl.LineNr.fg = "#B4B4B4"
				hl.TelescopeNormal = {
					bg = c.bg,
					fg = c.fg,
				}
				hl.TelescopeBorder = {
					bg = c.bg,
					fg = c.fg,
				}
				hl.TelescopePromptNormal = {
					bg = c.bg,
				}
				hl.TelescopePromptBorder = {
					bg = c.bg,
					fg = c.fg,
				}
				hl.TelescopePromptTitle = {
					bg = c.bg,
					fg = c.fg,
				}
				hl.TelescopePreviewTitle = {
					bg = c.bg,
					fg = c.fg,
				}
				hl.TelescopeResultsTitle = {
					bg = c.bg,
					fg = c.fg,
				}
			end,
		})
		vim.cmd([[colorscheme tokyonight]])
	end,
}
