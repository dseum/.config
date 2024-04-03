return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        on_highlights = function(hl, c)
          hl.LineNr.fg = "#7D85A7"
          hl.TelescopePromptBorder =
            { fg = c.border_highlight, bg = c.bg_float }
          hl.TelescopePromptTitle = { fg = c.border_highlight, bg = c.bg_float }
        end,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
