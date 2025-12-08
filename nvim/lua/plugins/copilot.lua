return {
	"github/copilot.vim",
	event = "InsertEnter",
	config = function()
		-- Copilot settings
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""

		-- Keymaps for copilot
		local keymap = vim.keymap.set

		-- Accept suggestion
		keymap("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
		keymap("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

		-- Dismiss suggestion
		keymap("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss copilot suggestion" })

		-- Next/Previous suggestion
		keymap("i", "<C-\\>", "<Plug>(copilot-next)", { desc = "Next copilot suggestion" })
		keymap("i", "<C-[>", "<Plug>(copilot-previous)", { desc = "Previous copilot suggestion" })

		-- Panel
		keymap("i", "<C-o>", "<Plug>(copilot-suggest)", { desc = "Trigger copilot suggestion" })
	end,
}
