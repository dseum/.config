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
            init_selection = "<cr>",
            node_incremental = "<cr>",
            node_decremental = "<s-cr>",
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
    "saghen/blink.cmp",
    dependenices = {
      "folke/lazydev.nvim",
      "rafamadriz/friendly-snippets",
    },
    version = "0.10.0",
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
      },
      keymap = {
        preset = "none",
        ["<c-p>"] = { "select_prev", "fallback" },
        ["<c-n>"] = { "select_next", "fallback" },
        ["<c-u>"] = { "scroll_documentation_down", "fallback" },
        ["<c-d>"] = { "scroll_documentation_up", "fallback" },
        ["<c-space>"] = {
          "show",
          "hide",
        },
        ["<tab>"] = {
          "accept",
          "fallback",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
    },
    config = function()
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
        ruff = { "ruff" },
        rust_analyzer = { "rust-analyzer" },
        svelte = { "svelte-language-server" },
        tailwindcss = { "tailwindcss-language-server" },
        taplo = { "taplo" },
        texlab = { "texlab" },
        ts_ls = {
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
        local M = {}
        require("lspconfig")[server_id].setup(
          vim.tbl_deep_extend("keep", server_config, {
            capabilities = require("blink.cmp").get_lsp_capabilities(
              server_config.capabilities
            ),
            on_init = function(client)
              if client.server_capabilities then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
            handlers = {
              ["experimental/serverStatus"] = function(_, result, ctx, _)
                if result.quiescent and not M.ran_once then
                  for _, bufnr in
                    ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id))
                  do
                    vim.lsp.inlay_hint.enable(false, {
                      bufnr = bufnr,
                    })
                    vim.lsp.inlay_hint.enable(true, {
                      bufnr = bufnr,
                    })
                  end
                  M.ran_once = true
                end
              end,
            },
            on_attach = function(client, bufnr)
              if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, {
                  bufnr = bufnr,
                })
              end
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
                "<c-k>",
                vim.lsp.buf.signature_help,
                { desc = "Signature Documentation" }
              )
              vim.keymap.set(
                "n",
                "K",
                vim.lsp.buf.hover,
                { desc = "Hover Documentation" }
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
        ["tex-fmt"] = {
          args = { "--stdin", "--nowrap" },
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
        nix = { "nixfmt" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format" },
        rmd = { "rmd" },
        sh = { "shfmt" },
        svelte = { "prettierd" },
        tex = { "tex-fmt" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        rust = { "rustfmt" },
        yaml = { "prettierd" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
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
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_view_method = "sioyek"
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
