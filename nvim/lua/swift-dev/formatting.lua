-- Swift formatting configuration (swiftformat)

local function setup_swift_formatting()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return
	end

	-- Ensure formatters_by_ft exists
	if not conform.formatters_by_ft then
		-- If conform hasn't been setup yet, we'll set it up
		conform.setup({
			formatters_by_ft = {
				swift = { "swiftformat" },
			},
		})
	else
		-- Add Swift formatter to existing config
		conform.formatters_by_ft.swift = { "swiftformat" }
	end
end

-- Setup when conform is available
vim.api.nvim_create_autocmd("FileType", {
	pattern = "swift",
	callback = function()
		setup_swift_formatting()
	end,
})

-- Also try to setup immediately if conform is already loaded
-- Use a timer to ensure conform plugin has loaded
vim.defer_fn(function()
	setup_swift_formatting()
end, 100)
