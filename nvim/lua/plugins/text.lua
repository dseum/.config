return {
  "tpope/vim-sleuth",
  "tpope/vim-surround",
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
        callback = function(args)
          if vim.bo.buftype ~= "" then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
}
