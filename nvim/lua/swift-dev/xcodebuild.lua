-- XcodeBuild.nvim configuration for Swift/Xcode projects
-- Plugin: https://github.com/wojciech-kulik/xcodebuild.nvim

local function setup_xcodebuild()
	local ok, xcodebuild = pcall(require, "xcodebuild")
	if not ok then
		return
	end

	xcodebuild.setup({
		-- Configuration options for xcodebuild.nvim
		-- See https://github.com/wojciech-kulik/xcodebuild.nvim for all options
	})

	-- Key bindings for xcodebuild.nvim
	-- Using <leader>x prefix for Xcode-related commands
	local map = vim.keymap.set

	-- Helper to safely bind commands
	local function safe_bind(mode, key, func, desc)
		if type(func) == "function" then
			map(mode, key, func, { desc = desc, noremap = true, silent = true })
		end
	end

	-- Project management
	safe_bind("n", "<leader>xp", xcodebuild.pick_project, "Pick Xcode Project")
	safe_bind("n", "<leader>xs", xcodebuild.pick_scheme, "Pick Scheme")
	safe_bind("n", "<leader>xd", xcodebuild.pick_destination, "Pick Destination")

	-- Build and run
	safe_bind("n", "<leader>xb", xcodebuild.build, "Build Project")
	safe_bind("n", "<leader>xr", xcodebuild.build_and_run, "Build and Run")
	safe_bind("n", "<leader>xR", xcodebuild.run, "Run Without Building")
	safe_bind("n", "<leader>xq", xcodebuild.quick_build, "Quick Build")

	-- Testing
	safe_bind("n", "<leader>xt", xcodebuild.run_tests, "Run Tests")
	safe_bind("n", "<leader>xT", xcodebuild.run_class_tests, "Run Class Tests")
	safe_bind("n", "<leader>xc", xcodebuild.cancel, "Cancel Build/Tests")

	-- Navigation and UI
	safe_bind("n", "<leader>xl", xcodebuild.toggle_logs, "Toggle Build Logs")
	safe_bind("n", "<leader>xf", xcodebuild.toggle_failing_snapshots, "Toggle Failing Snapshots")
	safe_bind("n", "<leader>xe", xcodebuild.focus_logs, "Focus Logs")
	safe_bind("n", "<leader>xo", xcodebuild.open_project_config, "Open Project Config")

	-- Test navigation (when in a test file)
	safe_bind("n", "<leader>xn", xcodebuild.goto_next_failure, "Next Test Failure")
	safe_bind("n", "<leader>xN", xcodebuild.goto_prev_failure, "Previous Test Failure")
end

-- Setup when xcodebuild is available
vim.defer_fn(function()
	setup_xcodebuild()
end, 200)
