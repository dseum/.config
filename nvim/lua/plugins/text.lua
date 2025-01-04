return {
  { "echasnovski/mini.surround", opts = {} },
  { "echasnovski/mini.ai", opts = {} },
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        options = {
          indent_at_cursor = false,
        },
        symbol = "▏",
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.bo.buftype ~= "" then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
  {
    "tpope/vim-sleuth",
  },
}
