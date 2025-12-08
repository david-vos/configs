-- Swift LSP (sourcekit-lsp) configuration

local function setup_sourcekit(on_attach)
	-- Only setup if lspconfig is available
	-- Note: Using require('lspconfig') shows a deprecation warning but still works
	-- The warning is expected and can be ignored until the new API is stable
	local ok, lspconfig = pcall(require, "lspconfig")
	if not ok then
		return
	end

	-- Find sourcekit-lsp binary (system binary on macOS)
	local sourcekit_path = vim.fn.exepath("sourcekit-lsp")
	if sourcekit_path == "" then
		vim.notify("sourcekit-lsp not found. Please ensure Xcode Command Line Tools are installed.", vim.log.levels.WARN)
		return
	end

	-- Setup sourcekit-lsp for Swift
	-- Note: Using require('lspconfig') is deprecated but still works
	-- Will be updated when the new API is finalized
	lspconfig.sourcekit.setup({
		cmd = { sourcekit_path },
		filetypes = { "swift", "objective-c", "objective-cpp" },
		root_dir = function(fname)
			-- Look for Package.swift, *.xcodeproj, or *.xcworkspace
			local util = require("lspconfig.util")
			local root = util.root_pattern("Package.swift", "*.xcodeproj", "*.xcworkspace")(fname)
				or util.find_git_ancestor(fname)
			
			-- If we found a root with Package.swift, ensure .build exists (package has been built)
			if root then
				local package_swift = root .. "/Package.swift"
				local build_dir = root .. "/.build"
				if vim.fn.filereadable(package_swift) == 1 and vim.fn.isdirectory(build_dir) == 0 then
					-- Package.swift exists but .build doesn't - suggest building
					vim.notify("Swift package not built. Run 'swift build' for SourceKit-LSP to work properly.", vim.log.levels.WARN)
				end
			end
			
			return root or vim.fn.getcwd()
		end,
		settings = {
			-- Swift Package Manager specific settings
			sourcekit = {
				-- Enable indexing for better code completion
				indexWhileBuilding = true,
			},
		},
		capabilities = {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
		-- Additional initialization options for Swift Package Manager
		init_options = {
			-- This helps SourceKit-LSP understand the package structure
		},
		on_attach = on_attach,
		-- Single file support is limited, but we can try
		single_file_support = false,
	})
end

-- Export for use in main lsp.lua
return {
	setup_sourcekit = setup_sourcekit,
}
