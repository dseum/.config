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
        symbol = "▏",
      })
    end,
  },
}
