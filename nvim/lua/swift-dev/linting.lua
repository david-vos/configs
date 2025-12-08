-- Swift linting configuration (swiftlint)

local function setup_swift_linting()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return
	end

	-- Ensure linters_by_ft exists
	if not lint.linters_by_ft then
		lint.linters_by_ft = {}
	end

	-- Add Swift linter
	lint.linters_by_ft.swift = { "swiftlint" }

	-- Swift-specific linting autocmd
	local lint_augroup = vim.api.nvim_create_augroup("swift_lint", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
		group = lint_augroup,
		pattern = { "*.swift" },
		callback = function()
			-- Skip swiftinterface files
			if not vim.endswith(vim.fn.bufname(), "swiftinterface") then
				require("lint").try_lint()
			end
		end,
	})
end

-- Setup when lint is available
vim.api.nvim_create_autocmd("FileType", {
	pattern = "swift",
	callback = function()
		setup_swift_linting()
	end,
})

-- Also try to setup immediately if lint is already loaded
-- Use a timer to ensure lint plugin has loaded
vim.defer_fn(function()
	setup_swift_linting()
end, 100)
