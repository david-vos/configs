return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.extend_lspconfig()
			lsp_zero.extend_cmp()

			-- Configure diagnostics to show virtual text inline
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 0,
					source = "always",
					severity = {
						min = vim.diagnostic.severity.HINT,
					},
					format = function(diagnostic)
						local icons = {
							Error = "✗",
							Warn = "⚠",
							Info = "ℹ",
							Hint = "→",
						}
						local icon = icons[diagnostic.severity] or "○"
						return string.format("%s %s", icon, diagnostic.message)
					end,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Define on_attach handler first so it can be used in custom handlers
			local on_attach_handler = function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
				
				-- Enable inlay hints for type annotations (skip Copilot)
				if client.name ~= "copilot" and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
				
				-- Helper function to get the primary LSP client (not Copilot)
				local function get_primary_client()
					-- Use new API: vim.lsp.get_clients() instead of deprecated get_active_clients()
					local clients = vim.lsp.get_clients({ bufnr = bufnr })
					for _, c in ipairs(clients) do
						if c.name ~= "copilot" then
							return c
						end
					end
					return client -- Fallback to current client
				end
				
				-- Explicit keymaps for LSP functions
				local opts = { buffer = bufnr, remap = false }
				
				-- Goto definition (using Telescope with centered popup)
				vim.keymap.set("n", "gd", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/definition") then
						local ok, builtin = pcall(require, "telescope.builtin")
						if ok then
							-- Use Telescope for definition with centered popup
							builtin.lsp_definitions({
								show_line = true,
								fname_width = 50,
								symbol_width = 50,
								-- Center popup layout (like fzf)
								layout_strategy = "center",
								layout_config = {
									width = 0.9,
									height = 0.8,
									preview_cutoff = 1,
									prompt_position = "top",
									anchor = "N",
								},
								initial_mode = "normal",
								path_display = { "smart" },
								trim_text = true,
							})
						else
							-- Fallback to default behavior
							vim.lsp.buf.definition()
						end
					else
						vim.notify("Definition not supported", vim.log.levels.WARN)
					end
				end, opts)
				
				-- Goto declaration (Telescope doesn't have lsp_declarations, use native LSP)
				vim.keymap.set("n", "gD", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/declaration") then
						-- Telescope doesn't have lsp_declarations, use native LSP method
						vim.lsp.buf.declaration()
					else
						vim.notify("Declaration not supported", vim.log.levels.WARN)
					end
				end, opts)
				
				-- Goto type definition (using Telescope with centered popup)
				vim.keymap.set("n", "gt", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/typeDefinition") then
						local ok, builtin = pcall(require, "telescope.builtin")
						if ok then
							builtin.lsp_type_definitions({
								show_line = true,
								fname_width = 50,
								symbol_width = 50,
								layout_strategy = "center",
								layout_config = {
									width = 0.9,
									height = 0.8,
									preview_cutoff = 1,
									prompt_position = "top",
									anchor = "N",
								},
								initial_mode = "normal",
								path_display = { "smart" },
								trim_text = true,
							})
						else
							vim.lsp.buf.type_definition()
						end
					else
						vim.notify("Type definition not supported", vim.log.levels.WARN)
					end
				end, opts)
				
				-- Find references (using Telescope with optimized settings)
				vim.keymap.set("n", "gr", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/references") then
						local ok, builtin = pcall(require, "telescope.builtin")
						if ok then
							-- Use optimized Telescope picker for references
							-- Center layout like fzf or command line
							builtin.lsp_references({
								include_declaration = true, -- Include declaration in results
								show_line = true,
								fname_width = 50,
								symbol_width = 50,
								-- Center popup layout (like fzf)
								layout_strategy = "center",
								layout_config = {
									width = 0.9,
									height = 0.8,
									preview_cutoff = 1,
									prompt_position = "top",
									anchor = "N",
								},
								-- Performance optimizations
								initial_mode = "normal",
								path_display = { "smart" },
								-- Show more context
								trim_text = true,
							})
						else
							vim.lsp.buf.references()
						end
					else
						vim.notify("References not supported", vim.log.levels.WARN)
					end
				end, opts)
				
				-- Go to usages (same as references, but with explicit keybinding)
				vim.keymap.set("n", "<leader>gu", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/references") then
						local ok, builtin = pcall(require, "telescope.builtin")
						if ok then
							builtin.lsp_references({
								include_declaration = true,
								show_line = true,
								layout_strategy = "center",
								layout_config = {
									width = 0.9,
									height = 0.8,
									preview_cutoff = 1,
									prompt_position = "top",
									anchor = "N",
								},
								initial_mode = "normal",
								path_display = { "smart" },
								trim_text = true,
							})
						else
							vim.lsp.buf.references()
						end
					else
						vim.notify("References not supported", vim.log.levels.WARN)
					end
				end, { buffer = bufnr, desc = "Go to usages (find all references)" })
				
				-- Find implementations (using Telescope with centered popup)
				vim.keymap.set("n", "gi", function()
					local primary_client = get_primary_client()
					if primary_client and primary_client:supports_method("textDocument/implementation") then
						local ok, builtin = pcall(require, "telescope.builtin")
						if ok then
							builtin.lsp_implementations({
								show_line = true,
								fname_width = 50,
								symbol_width = 50,
								layout_strategy = "center",
								layout_config = {
									width = 0.9,
									height = 0.8,
									preview_cutoff = 1,
									prompt_position = "top",
									anchor = "N",
								},
								initial_mode = "normal",
								path_display = { "smart" },
								trim_text = true,
							})
						else
							vim.lsp.buf.implementation()
						end
					else
						vim.notify("Implementation not supported", vim.log.levels.WARN)
					end
				end, opts)
				
				-- Hover
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				
				-- Rename
				vim.keymap.set("n", "<leader>rn", function()
					vim.lsp.buf.rename()
				end, opts)
				
				-- Code actions
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts)
				
				-- Toggle inlay hints
				if vim.lsp.inlay_hint then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
					end, { buffer = bufnr, desc = "Toggle inlay hints" })
				end
			end

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					-- Default handler for all LSPs
					function(server_name)
						require("lspconfig")[server_name].setup({
							on_attach = on_attach_handler,
						})
					end,

					-- Custom handler for lua_ls
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						lua_opts.on_attach = on_attach_handler
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})

			-- Setup sourcekit (Swift) directly since it's not available via Mason
			-- It's a system binary on macOS
			-- Defer setup to avoid blocking startup with deprecation warnings
			vim.schedule(function()
				local swift_lsp = require("swift-dev.lsp")
				swift_lsp.setup_sourcekit(on_attach_handler)
			end)

			-- Register the on_attach handler with lsp-zero
			lsp_zero.on_attach(on_attach_handler)
		end,
	},
}

