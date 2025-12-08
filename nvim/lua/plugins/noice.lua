return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})

		-- Keymaps for noice
		vim.keymap.set("n", "<S-Enter>", function()
			require("noice").redirect(vim.fn.getcmdline())
		end, { desc = "Redirect Cmdline" })

		vim.keymap.set("n", "<leader>snl", function()
			require("noice").cmd("last")
		end, { desc = "Noice Last Message" })

		vim.keymap.set("n", "<leader>snh", function()
			require("noice").cmd("history")
		end, { desc = "Noice History" })

		vim.keymap.set("n", "<leader>sna", function()
			require("noice").cmd("all")
		end, { desc = "Noice All" })

		vim.keymap.set("n", "<c-f>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-f>"
			end
		end, { silent = true, expr = true })

		vim.keymap.set("n", "<c-b>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-b>"
			end
		end, { silent = true, expr = true })
	end,
}
