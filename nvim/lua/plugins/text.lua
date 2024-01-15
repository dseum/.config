return {
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  {
    "echasnovski/mini.pairs",
    opts = {
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%a%d]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%a%d]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%a%d]" },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        ['"'] = {
          action = "closeopen",
          pair = '""',
          neigh_pattern = '[^%a%d\\"][^%a%d]',
          register = { cr = false },
        },
        ["'"] = {
          action = "closeopen",
          pair = "''",
          neigh_pattern = "[^%a%d\\<'][^%a%d]",
          register = { cr = false },
        },
        ["`"] = {
          action = "closeopen",
          pair = "``",
          neigh_pattern = "[^%a%d\\`][^%a%d]",
          register = { cr = false },
        },
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "echasnovski/mini.comment",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },
}
