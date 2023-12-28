return {
	"tpope/vim-vinegar",
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {
						"TelescopePrompt",
						"mason",
						"lazy",
						"netrw",
					},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 1,
						shorting_target = 40,
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[U]",
							newfile = "[N]",
						},
						color = nil,
					},
				},
				lualine_b = {
					"diagnostics",
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>pf", "<cmd>Telescope find_files<cr>" },
			{ "<leader>pg", "<cmd>Telescope git_files<cr>" },
			{ "<leader>ps", "<cmd>Telescope live_grep<cr>" },
		},
		config = function()
			local with_name = function(name)
				return {
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
					prompt_title = name,
					results_title = false,
					preview_title = false,
					layout_config = {
						prompt_position = "top",
					},
				}
			end
			pcall(require("telescope").load_extension, "fzf")
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						".git/.*",
						"_build/.*",
					},
				},
				pickers = {
					find_files = with_name("Files"),
					git_files = with_name("Git"),
					live_grep = with_name("Grep"),
					lsp_references = with_name("References"),
					lsp_document_symbols = with_name("Document Symbols"),
					lsp_dynamic_workspace_symbols = with_name("Workspace Symbols"),
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"mbbill/undotree",
		keys = { { "<leader>u", vim.cmd.UndotreeToggle } },
	},
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", vim.cmd.Git },
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
					"<leader>gp",
					require("gitsigns").prev_hunk,
					{ buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>gn",
					require("gitsigns").next_hunk,
					{ buffer = bufnr, desc = "[G]o to [N]ext Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>ph",
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
			{ "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>tT", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>tL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>tQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
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
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>bd",
				function()
					local wins = vim.fn.win_findbuf(vim.api.nvim_get_current_buf())
					if #wins > 1 then
						require("mini.bufremove").unshow_in_window(wins[0])
					else
						require("mini.bufremove").delete(0, false)
					end
				end,
				desc = "Close Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
	},
}
