return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<Leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<Leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
          "rafamadriz/friendly-snippets",
        },
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Completion
      require("luasnip.loaders.from_vscode").lazy_load()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })

      -- LSP
      local servers = {
        rust_analyzer = {},
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        tailwindcss = {},
        tsserver = {
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "non-relative",
            },
          },
        },
        html = {},
        jsonls = {},
        svelte = {},
        texlab = {
          settings = {
            texlab = {
              auxDirectory = ".",
              bibtexFormatter = "texlab",
              build = {
                args = {
                  "-pdf",
                  "-interaction=nonstopmode",
                  "-synctex=1",
                  "%f",
                },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = true,
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = false,
              },
              diagnosticsDelay = 300,
              formatterLineLength = 80,
              forwardSearch = {
                args = {},
              },
              latexFormatter = "latexindent",
              latexindent = {
                modifyLineBreaks = false,
              },
            },
          },
        },
        taplo = {},
        dockerls = {},
        docker_compose_language_service = {},
        yamlls = {},
        pyre = {},
        ocamllsp = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      require("mason").setup()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup(
              vim.tbl_deep_extend("keep", {
                capabilities = capabilities,
                on_init = function(client)
                  if client.server_capabilities then
                    client.server_capabilities.semanticTokensProvider = nil
                  end
                end,
                on_attach = function()
                  vim.keymap.set(
                    "n",
                    "<Leader>rn",
                    vim.lsp.buf.rename,
                    { desc = "[R]e[n]ame" }
                  )
                  vim.keymap.set(
                    "n",
                    "<Leader>ca",
                    vim.lsp.buf.code_action,
                    { desc = "[C]ode [A]ction" }
                  )
                  vim.keymap.set(
                    "n",
                    "gd",
                    vim.lsp.buf.definition,
                    { desc = "[G]oto [D]efinition" }
                  )
                  vim.keymap.set(
                    "n",
                    "gr",
                    require("telescope.builtin").lsp_references,
                    { desc = "[G]oto [R]eferences" }
                  )
                  vim.keymap.set(
                    "n",
                    "gI",
                    vim.lsp.buf.implementation,
                    { desc = "[G]oto [I]mplementation" }
                  )
                  vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.declaration,
                    { desc = "[G]oto [D]eclaration" }
                  )
                  vim.keymap.set(
                    "n",
                    "K",
                    vim.lsp.buf.hover,
                    { desc = "Hover Documentation" }
                  )
                  vim.keymap.set(
                    "n",
                    "<C-k>",
                    vim.lsp.buf.signature_help,
                    { desc = "Signature Documentation" }
                  )
                end,
              }, servers[server_name])
            )
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          css = { "prettierd" },
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          svelte = { "prettierd" },
          json = { "prettierd" },
          jsonc = { "prettierd" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          conf = { "shfmt" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          dart = { "dart_format" },
          ocaml = { "ocamlformat" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<S-Tab>", [[copilot#Accept("")]], {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
  { "echasnovski/mini.doc", enabled = false, config = true },
}
