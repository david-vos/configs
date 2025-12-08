-- Swift Treesitter configuration

local function setup_swift_treesitter()
	-- Ensure Swift parser is installed
	local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
	if not ok then
		return
	end

	-- Swift parser should already be in ensure_installed from main treesitter config
	-- This file exists for any Swift-specific treesitter settings in the future
end

setup_swift_treesitter()
