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
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
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
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },
      })

      local luasnip = require("luasnip")
      local cmp = require("cmp")
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "hrsh7th/nvim-cmp",
      "williamboman/mason.nvim",
    },
    config = function()
      require("neodev").setup()

      local servers = {
        bashls = { "bash-language-server" },
        coq_lsp = {},
        cssls = {
          "css-lsp",
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        dafny = {},
        docker_compose_language_service = { "docker-compose-language-server" },
        dockerls = { "dockerfile-language-server" },
        gopls = { "gopls" },
        html = { "html-lsp" },
        jsonls = { "json-lsp" },
        lua_ls = {
          "lua-language-server",
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        ocamllsp = {},
        pyre = { "pyre" },
        r_language_server = { "r-languageserver" },
        rust_analyzer = { "rust-analyzer" },
        svelte = { "svelte-language-server" },
        tailwindcss = { "tailwindcss-language-server" },
        taplo = { "taplo" },
        texlab = { "texlab" },
        tsserver = {
          "typescript-language-server",
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "non-relative",
            },
          },
        },
        yamlls = { "yaml-language-server" },
        zls = { "zls" },
      }

      require("mason").setup()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local MasonPackage = require("mason-core.package")
      local MasonOptional = require("mason-core.optional")
      local MasonRegistry = require("mason-registry")

      for server_id, server_config in pairs(servers) do
        -- Install LSP
        local pkg_name = server_config[1]
        if type(pkg_name) == "string" then
          -- Assume package is valid
          MasonOptional.of_nilable(pkg_name)
            :map(function(name)
              local ok, pkg = pcall(MasonRegistry.get_package, name)
              if ok then
                return pkg
              end
            end)
            :if_present(
              ---@param pkg Package
              function(pkg)
                if not pkg:is_installed() then
                  local _, version = MasonPackage.Parse(server_id)
                  pkg:install({ version = version })
                end
              end
            )
          server_config[1] = nil
        end

        -- Setup LSP
        require("lspconfig")[server_id].setup(
          vim.tbl_deep_extend("keep", server_config, {
            capabilities = capabilities,
            on_init = function(client)
              if client.server_capabilities then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
            on_attach = function()
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
          })
        )
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        caddyfile = {
          command = "caddy",
          args = { "fmt", "-" },
        },
        latexindent = {
          prepend_args = { [[-y="defaultIndent:'  '"]] },
        },
        rmd = {
          command = "Rscript",
          args = {
            "-e",
            [[
              options(styler.quiet = TRUE)
              con <- file("stdin")
              temp <- tempfile("styler", fileext = ".Rmd")
              writeLines(readLines(con), temp)
              styler::style_file(temp, scope="line_breaks")
              output <- paste0(readLines(temp), collapse = '\n')
              cat(output)
              close(con)
            ]],
          },
        },
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang_format" },
        caddyfile = { "caddyfile" },
        conf = { "shfmt" },
        cpp = { "clang_format" },
        css = { "prettierd" },
        dart = { "dart_format" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format" },
        rmd = { "rmd" },
        sh = { "shfmt" },
        svelte = { "prettierd" },
        tex = { "latexindent" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
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
        python = { "ruff" },
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
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        oil = false,
      }
    end,
    config = function()
      vim.keymap.set("i", "<S-Tab>", [[copilot#Accept("")]], {
        expr = true,
        replace_keycodes = false,
      })
    end,
  },
  {
    "dseum/demia.nvim",
    dev = true,
    opts = {},
  },
}
