return {
  "tpope/vim-commentary",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  {
    "echasnovski/mini.comment",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring({
            location = require("ts_context_commentstring.utils").get_cursor_location(),
          }) or vim.bo.commentstring
        end,
      },
    },
  },
}
