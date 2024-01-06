return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "folke/tokyonight.nvim",
    },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local AlignBlock = {
        provider = "%=",
      }
      local SpaceBlock = {
        provider = " ",
      }

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then
            return "[No Name]"
          end
          return filename
        end,
        hl = {
          fg = utils.get_highlight("Directory").fg,
          bg = utils.get_highlight("StatusLine").bg,
        },
      }
      local FileNameModified = {
        hl = function()
          if vim.bo.modified then
            return { fg = "cyan", force = true }
          end
        end,
      }
      local FileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      FileNameBlock = utils.insert(
        FileNameBlock,
        utils.insert(FileNameModified, FileName),
        { provider = "%<" }
      )

      local DiagnosticBlock = {
        condition = conditions.has_diagnostics,
        init = function(self)
          self.error = {
            count = #vim.diagnostic.get(
              0,
              { severity = vim.diagnostic.severity.ERROR }
            ),
            symbol = "E",
          }
          self.warn = {
            count = #vim.diagnostic.get(
              0,
              { severity = vim.diagnostic.severity.WARN }
            ),
            symbol = "W",
          }
          self.info = {
            count = #vim.diagnostic.get(
              0,
              { severity = vim.diagnostic.severity.INFO }
            ),
            symbol = "I",
          }
          self.hint = {
            count = #vim.diagnostic.get(
              0,
              { severity = vim.diagnostic.severity.HINT }
            ),
            symbol = "H",
          }
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        {
          provider = function(self)
            return self.error.symbol .. self.error.count
          end,
          hl = { fg = "error", bg = utils.get_highlight("StatusLine").bg },
        },
        SpaceBlock,
        {
          provider = function(self)
            return self.warn.symbol .. self.warn.count
          end,
          hl = { fg = "warning", bg = utils.get_highlight("StatusLine").bg },
        },
        SpaceBlock,
        {
          provider = function(self)
            return self.info.symbol .. self.info.count
          end,
          hl = { fg = "info", bg = utils.get_highlight("StatusLine").bg },
        },
        SpaceBlock,
        {
          provider = function(self)
            return self.hint.symbol .. self.hint.count
          end,
          hl = { fg = "hint", bg = utils.get_highlight("StatusLine").bg },
        },
      }

      require("heirline").setup({
        statusline = {
          FileNameBlock,
          AlignBlock,
          DiagnosticBlock,
        },
        opts = {
          colors = require("tokyonight.colors").setup(),
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = {
      { "<Leader>pf", "<Cmd>Telescope frecency workspace=CWD<CR>" },
      { "<Leader>ps", "<Cmd>Telescope live_grep<CR>" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            ".git/.*",
            "_build/.*",
            "lazy%-lock.json",
            "package%-lock.json",
          },
          borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          sorting_strategy = "ascending",
          hidden = true,
          prompt_prefix = "— ",
          selection_caret = "— ",
          results_height = 20,
          results_title = false,
          preview_title = false,
          layout_config = {
            prompt_position = "top",
          },
        },
        pickers = {
          live_grep = {
            prompt_title = "Grep",
          },
        },
        extensions = {
          frecency = {
            disable_devicons = true,
            workspace_scan_cmd = { "fd", "-Htf" },
          },
        },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "mbbill/undotree",
    keys = { { "<Leader>u", vim.cmd.UndotreeToggle } },
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      { "<Leader>gs", vim.cmd.Git },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<Leader>gp",
          require("gitsigns").prev_hunk,
          { buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
        )
        vim.keymap.set(
          "n",
          "<Leader>gn",
          require("gitsigns").next_hunk,
          { buffer = bufnr, desc = "[G]o to [N]ext Hunk" }
        )
        vim.keymap.set(
          "n",
          "<Leader>ph",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "[P]review [H]unk" }
        )
      end,
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      icons = false,
      fold_open = "-",
      fold_closed = "+",
    },
    keys = {
      {
        "<Leader>tt",
        "<Cmd>TroubleToggle document_diagnostics<CR>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<Leader>tT",
        "<Cmd>TroubleToggle workspace_diagnostics<CR>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<Leader>tL",
        "<Cmd>TroubleToggle loclist<CR>",
        desc = "Location List (Trouble)",
      },
      {
        "<Leader>tQ",
        "<Cmd>TroubleToggle quickfix<CR>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            pcall(vim.cmd.cnext)
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  {
    "dseum/window.nvim",
    dev = true,
    lazy = false,
    opts = {},
    keys = {
      {
        "<Leader>ww",
        function()
          require("window").close_buf()
        end,
      },
      {
        "<Leader>wi",
        function()
          require("window").inspect()
        end,
      },
      {
        "<C-w>s",
        function()
          require("window").split_win("h")
        end,
      },
      {
        "<C-w>v",
        function()
          require("window").split_win("v")
        end,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = 0,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".."
        end,
      },
      float = {
        border = "solid",
      },
      preview = {
        border = "solid",
      },
      progress = {
        border = "solid",
      },
    },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
      },
      {
        "=",
        function()
          require("oil").open(vim.loop.cwd())
        end,
      },
    },
  },
}
