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
				sourcekit = {
					cmd = {
						"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
					},
				},
			}

			require("neodev").setup()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})
			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup(vim.tbl_deep_extend("keep", {
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							client.server_capabilities.semanticTokensProvider = nil

							local nmap = function(keys, func, desc)
								if desc then
									desc = "LSP: " .. desc
								end
								vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
							end
							nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
							nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
							nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
							nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
							nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
							nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
							nmap("K", vim.lsp.buf.hover, "Hover Documentation")
							nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
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
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "autopep8" },
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
	-- {
	--     "dseum/delta.nvim",
	--     dev = true,
	--     config = function()
	--         local packages = {
	--             prettier = {
	--                 exe = "prettierd",
	--                 type = "format",
	--                 args = {
	--                     "$FILE_NAME",
	--                 },
	--                 patterns = {
	--                     ".prettierrc",
	--                     ".prettierrc.json",
	--                     ".prettierrc.yml",
	--                     ".prettierrc.yaml",
	--                     ".prettierrc.json5",
	--                     ".prettierrc.js",
	--                     ".prettierrc.cjs",
	--                     ".prettierrc.toml",
	--                     "prettier.config.js",
	--                     "prettier.config.cjs",
	--                     "package.json",
	--                 },
	--             },
	--             stylua = {
	--                 exe = "stylua",
	--                 type = "format",
	--                 args = {
	--                     "--stdin-filepath",
	--                     "$FILE_NAME",
	--                     "-",
	--                 },
	--             },
	--             clang = {
	--                 exe = "clang-format",
	--                 type = "format",
	--                 args = {
	--                     "-assume-filename",
	--                     "$FILE_NAME",
	--                 },
	--             },
	--             eslint = {
	--                 exe = "eslint_d",
	--                 type = "lint",
	--                 args = {
	--                     "-f",
	--                     "json",
	--                     "--stdin",
	--                     "--stdin-filename",
	--                     "$FILE_NAME",
	--                 },
	--                 patterns = {
	--                     "eslint.config.js",
	--                     ".eslintrc",
	--                     ".eslintrc.js",
	--                     ".eslintrc.cjs",
	--                     ".eslintrc.yaml",
	--                     ".eslintrc.yml",
	--                     ".eslintrc.json",
	--                     "package.json",
	--                 },
	--             },
	--         }
	--         local delta = require("delta")
	--         delta.setup({
	--             {
	--                 filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
	--                 sequence = {
	--                     packages.prettier,
	--                     packages.eslint,
	--                 },
	--             },
	--             {
	--                 filetypes = { "css", "html", "json", "jsonc" },
	--                 sequence = {
	--                     packages.prettier,
	--                 },
	--             },
	--             {
	--                 filetypes = { "lua" },
	--                 sequence = {
	--                     packages.stylua,
	--                 },
	--             },
	--             {
	--                 filetypes = { "c", "cpp" },
	--                 sequence = {
	--                     packages.clang,
	--                 },
	--             },
	--         })
	--         delta.events.on_save(function()
	--             delta.api.format()
	--         end)
	--     end,
	-- },
}
