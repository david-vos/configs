return {
	"mbbill/undotree",
	config = function()
		-- Set keybinding to toggle Undotree
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })

		-- Enable persistent undo (if not already enabled)
		vim.opt.undofile = true
	end,
}

