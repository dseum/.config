return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        on_highlights = function(hl)
          hl.LineNr.fg = "#7D85A7"
        end,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
