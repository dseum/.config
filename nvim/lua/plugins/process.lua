return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
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
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true, build = ":MasonUpdate" },
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "nvim-telescope/telescope.nvim",
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
          "hrsh7th/cmp-nvim-lsp",
          "rafamadriz/friendly-snippets",
        },
      },
    },
    config = function()
      require("neodev").setup()

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
        ltex = {},
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        automatic_installation = {
          exclude = {},
        },
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup(vim.tbl_deep_extend("keep", {
            capabilities = capabilities,
            on_init = function(client)
              if client.server_capabilities then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
            on_attach = function(client, bufnr)
              vim.keymap.set(
                "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                { desc = "[R]e[n]ame" }
              )
              vim.keymap.set(
                "n",
                "<leader>ca",
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
          }, servers[server_name]))
        end,
      })

      -- Completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    enable = false,
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
          latex = { "latexindent" },
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
  "github/copilot.vim",
  "echasnovski/mini.doc",
}
