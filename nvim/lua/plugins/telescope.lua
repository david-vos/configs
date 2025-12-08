return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				-- Performance improvements
				debounce = 50,
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"%.build/",
					"%.swiftpm/",
				},
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-d>"] = false,
					},
				},
			},
			pickers = {
				-- Optimized configuration for LSP references
				lsp_references = {
					layout_strategy = "center",
					layout_config = {
						width = 0.9,
						height = 0.8,
						preview_cutoff = 1,
						prompt_position = "top",
						anchor = "N",
					},
					-- Show more results
					include_declaration = true,
					show_line = true,
					fname_width = 50,
					symbol_width = 50,
					-- Better sorting - show current file first, then by line number
					sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
				},
				-- Optimized configuration for LSP definitions
				lsp_definitions = {
					layout_strategy = "center",
					layout_config = {
						width = 0.9,
						height = 0.8,
						preview_cutoff = 1,
						prompt_position = "top",
						anchor = "N",
					},
					show_line = true,
					fname_width = 50,
					symbol_width = 50,
					sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
				},
				-- Optimized configuration for LSP type definitions
				lsp_type_definitions = {
					layout_strategy = "center",
					layout_config = {
						width = 0.9,
						height = 0.8,
						preview_cutoff = 1,
						prompt_position = "top",
						anchor = "N",
					},
					show_line = true,
					fname_width = 50,
					symbol_width = 50,
				},
				-- Optimized configuration for LSP implementations
				lsp_implementations = {
					layout_strategy = "center",
					layout_config = {
						width = 0.9,
						height = 0.8,
						preview_cutoff = 1,
						prompt_position = "top",
						anchor = "N",
					},
					show_line = true,
					fname_width = 50,
					symbol_width = 50,
				},
			},
		})

		-- Set keymaps
		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git files" })
		vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Live grep (search in files)" })
		vim.keymap.set("n", "<leader>pg", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Grep string" })
		vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Find help tags" })
	end,
}
