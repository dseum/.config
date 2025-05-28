return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "folke/tokyonight.nvim",
    },
    config = function()
      local utils = require("heirline.utils")

      local AlignBlock = {
        provider = "%=",
      }
      local SpaceBlock = {
        provider = " ",
      }
      local FilenameOrRecordingBlock = {
        init = function(self)
          self.filename     = vim.api.nvim_buf_get_name(0)
          self.recording    = vim.fn.reg_recording()
          self.is_recording = require("heirline.conditions").is_active() and self.recording ~= ""
        end,
        update = { "BufEnter", "BufModifiedSet", "RecordingEnter", "RecordingLeave" },
        provider = function(self)
          if
              self.is_recording then
            return "@" .. self.recording
          end
          local name = vim.fn.fnamemodify(self.filename, ":.")
          if name == "" then
            name = "[No Name]"
          end
          return "%<" .. name
        end,
        hl = function(self)
          local base_bg = utils.get_highlight("StatusLine").bg
          local fg, force = nil, false
          if self.is_recording then
            fg = "red"
          elseif vim.bo.modified then
            fg = "cyan"
            force = true
          else
            fg = utils.get_highlight("Directory").fg
          end
          return { fg = fg, bg = base_bg, force = force }
        end,
      }
      local DiagnosticBlock = {
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
          FilenameOrRecordingBlock,
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
      { "<leader>pf", "<cmd>Telescope find_files<cr>" },
      { "<leader>ps", "<cmd>Telescope live_grep<cr>" },
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
              ["<c-d>"] = "results_scrolling_down",
              ["<c-u>"] = "results_scrolling_up",
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
              "--exclude",
              ".git",
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
      { "<leader>u", "<cmd>UndotreeToggle<cr>" },
    },
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "gn", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.fn.getwinvar(win, "fugitive_status") ~= "" then
            vim.api.nvim_win_call(win, function()
              vim.cmd.close()
            end)
            return
          end
        end
        vim.cmd("Git")
      end)
      vim.keymap.set("n", "gN", function()
        vim.cmd("Git")
      end)
    end,
  },
  {
    "echasnovski/mini.diff",
    config = function()
      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = "+", change = "~", delete = "–" },
          priority = 6,
        },
      })
      vim.keymap.set("n", "go", function()
        local buf = vim.api.nvim_get_current_buf()
        require("mini.diff").toggle_overlay(buf)
      end)
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {
      icons = {
        indent = {
          fold_open = "- ",
          fold_closed = "+ ",
        },
        folder_closed = "",
        folder_open = "",
      },
    },
    keys = {
      {
        "<leader>xp",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Project Diagnostics (Trouble)",
      },
      {
        "<leader>xb",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "dseum/window.nvim",
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
      vim.keymap.set("n", "<leader>ww", function()
        window.close_buf()
      end)
      vim.keymap.set("n", "<leader>wi", function()
        window.inspect()
      end)
      vim.keymap.set("n", "<c-w>s", function()
        window.split_win({
          default_buffer = false,
        })
      end)
      vim.keymap.set("n", "<c-w>v", function()
        window.split_win({
          orientation = "v",
          default_buffer = false,
        })
      end)
      vim.keymap.set("n", "<leader>T", function()
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
        oil.open(vim.uv.cwd())
      end)
    end,
  },
}
