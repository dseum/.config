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
    },
    keys = {
      { "<Leader>pf", "<Cmd>Telescope find_files<CR>" },
      { "<Leader>ps", "<Cmd>Telescope live_grep<CR>" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "lazy%-lock.json",
            "package%-lock.json",
          },
          borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          prompt_prefix = "— ",
          selection_caret = "— ",
          sorting_strategy = "ascending",
          results_title = false,
          results_height = 20,
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<C-d>"] = "results_scrolling_down",
              ["<C-u>"] = "results_scrolling_up",
            },
          },
        },
        pickers = {
          find_files = {
            prompt_title = "Files",
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
            },
            preview_title = false,
          },
          live_grep = {
            prompt_title = "Grep",
            preview_title = false,
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "mbbill/undotree",
    keys = {
      { "<Leader>u", "<Cmd>UndotreeToggle<CR>" },
    },
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<Leader>gs", function()
        vim.cmd("Git")
      end)
    end,
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
        untracked = { text = "┆" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
      icons = false,
      fold_open = "-",
      fold_closed = "+",
    },
    keys = {
      {
        "<Leader>td",
        "<Cmd>TroubleToggle document_diagnostics<CR>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<Leader>tw",
        "<Cmd>TroubleToggle workspace_diagnostics<CR>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<Leader>tl",
        "<Cmd>TroubleToggle loclist<CR>",
        desc = "Location List (Trouble)",
      },
      {
        "<Leader>tq",
        "<Cmd>TroubleToggle quickfix<CR>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "dseum/window.nvim",
    dev = true,
    config = function()
      local window = require("window")
      window.setup()
      vim.api.nvim_create_autocmd("TermClose", {
        callback = function()
          local bufnr = tonumber(vim.fn.expand("<abuf>")) --[[@as number]]
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              require("window").close_buf()
            end
          end)
        end,
      })
      vim.keymap.set("n", "<Leader>ww", function()
        window.close_buf()
      end)
      vim.keymap.set("n", "<Leader>wi", function()
        window.inspect()
      end)
      vim.keymap.set("n", "<C-w>s", function()
        window.split_win({
          default_buffer = false,
        })
      end)
      vim.keymap.set("n", "<C-w>v", function()
        window.split_win({
          orientation = "v",
          default_buffer = false,
        })
      end)
      vim.keymap.set("n", "<Leader>T", function()
        window.split_win({
          orientation = "v",
          default_buffer = function()
            vim.cmd.terminal()
          end,
        })
      end)
    end,
  },
  {
    "stevearc/oil.nvim",
    config = function()
      local oil = require("oil")
      oil.setup({
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
      })
      vim.keymap.set("n", "-", function()
        oil.open()
      end)
      vim.keymap.set("n", "=", function()
        oil.open(vim.loop.cwd())
      end)
    end,
  },
}
