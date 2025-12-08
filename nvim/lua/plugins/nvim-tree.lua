return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvim_tree = require("nvim-tree")
		local api = require("nvim-tree.api")

		-- Disable netrw (the default file explorer)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- Setup nvim-tree
		nvim_tree.setup({
			sort_by = "case_sensitive",
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = false,
			},
		})

		-- Keymap to toggle file tree
		vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle file tree" })
	end,
}
