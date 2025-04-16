return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        on_highlights = function(hl, c)
          hl.LineNrAbove = {
            fg = c.dark5,
          }
          hl.LineNrBelow = {
            fg = c.dark5,
          }
          hl.TelescopePromptBorder = { fg = c.border_highlight, bg = c.bg_float }
          hl.TelescopePromptTitle = { fg = c.border_highlight, bg = c.bg_float }
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
