return {
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = {
          char = "▏",
        },
        scope = {
          show_start = false,
          show_end = false,
        },
      })
      local hooks = require("ibl.hooks")
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_tab_indent_level
      )
    end,
  },
}
