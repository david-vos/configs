vim.g.mapleader = " "

-- Ensure Esc works in insert mode
vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Helper function to create a floating popup window for build output
local function create_build_popup(cmd)
	-- Create a new buffer for the output
	local buf = vim.api.nvim_create_buf(false, true) -- non-listed, scratch buffer
	
	-- Get current window dimensions
	local width = vim.api.nvim_win_get_width(0)
	local height = vim.api.nvim_win_get_height(0)
	
	-- Calculate popup dimensions (80% of window, but max 80 cols and 20 rows)
	local popup_width = math.min(math.floor(width * 0.8), 80)
	local popup_height = math.min(math.floor(height * 0.8), 20)
	
	-- Calculate centered position
	local col = math.floor((width - popup_width) / 2)
	local row = math.floor((height - popup_height) / 2)
	
	-- Create floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "win",
		width = popup_width,
		height = popup_height,
		col = col,
		row = row,
		style = "minimal",
		border = "single",
		title = "Build Output",
		title_pos = "center",
	})
	
	-- Set buffer options to make it editable and yankable
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_option(buf, "readonly", false)
	vim.api.nvim_buf_set_option(buf, "buftype", "") -- Normal buffer, not scratch
	
	-- Set window options
	vim.api.nvim_win_set_option(win, "wrap", true)
	vim.api.nvim_win_set_option(win, "number", false)
	vim.api.nvim_win_set_option(win, "relativenumber", false)
	
	-- Add initial message
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Running: " .. cmd, "", "Output will appear here..." })
	
	-- Run the command and capture output
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				-- Append output to buffer
				local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				-- Remove the "Output will appear here..." line if it exists
				if #current_lines > 2 and current_lines[#current_lines] == "Output will appear here..." then
					current_lines[#current_lines] = nil
				end
				-- Append new data
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(current_lines, line)
					end
				end
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, current_lines)
				-- Scroll to bottom
				vim.api.nvim_win_set_cursor(win, { #current_lines, 0 })
			end
		end,
		on_stderr = function(_, data)
			if data then
				local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				if #current_lines > 2 and current_lines[#current_lines] == "Output will appear here..." then
					current_lines[#current_lines] = nil
				end
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(current_lines, line)
					end
				end
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, current_lines)
				vim.api.nvim_win_set_cursor(win, { #current_lines, 0 })
			end
		end,
		on_exit = function(_, exit_code)
			local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			if #current_lines > 2 and current_lines[#current_lines] == "Output will appear here..." then
				current_lines[#current_lines] = nil
			end
			table.insert(current_lines, "")
			table.insert(current_lines, "--- Build finished with exit code: " .. exit_code .. " ---")
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, current_lines)
			vim.api.nvim_win_set_cursor(win, { #current_lines, 0 })
		end,
	})
	
	-- Function to close window and delete buffer
	local function close_popup()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		-- Buffer deletion will be handled by WinClosed autocmd
	end
	
	-- Set keymap to close with q
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", { callback = close_popup, noremap = true, silent = true })
	
	-- Override :q command for this buffer to close and delete
	vim.api.nvim_create_autocmd("BufWinEnter", {
		buffer = buf,
		once = true,
		callback = function()
			local close_cmd = string.format(
				"command! -buffer -bang q lua if vim.api.nvim_win_is_valid(%d) then vim.api.nvim_win_close(%d, true) end",
				win, win
			)
			vim.cmd(close_cmd)
		end,
	})
	
	-- Ensure buffer is deleted when window closes
	vim.api.nvim_create_autocmd("WinClosed", {
		callback = function(event)
			if tonumber(event.match) == win then
				-- Check if buffer is still valid before deleting
				if vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end,
	})
	
	-- Focus the window
	vim.api.nvim_set_current_win(win)
end

-- Build command - detects project type and runs appropriate build
vim.keymap.set("n", "<leader>bb", function()
	local cwd = vim.fn.getcwd()
	local build_cmd = nil
	
	-- Check for Swift Package Manager
	if vim.fn.filereadable(cwd .. "/Package.swift") == 1 then
		build_cmd = "swift build"
	end
	
	-- Check for Xcode project
	if not build_cmd then
		local xcode_projects = vim.fn.glob(cwd .. "/*.xcodeproj")
		if xcode_projects ~= "" then
			vim.notify("Xcode project detected. Use xcodebuild or Xcode to build.", vim.log.levels.INFO)
			return
		end
	end
	
	-- Check for Go project
	if not build_cmd and vim.fn.filereadable(cwd .. "/go.mod") == 1 then
		build_cmd = "go build"
	end
	
	-- Check for Node.js project
	if not build_cmd and vim.fn.filereadable(cwd .. "/package.json") == 1 then
		build_cmd = "npm run build"
	end
	
	-- Check for Makefile
	if not build_cmd and (vim.fn.filereadable(cwd .. "/Makefile") == 1 or vim.fn.filereadable(cwd .. "/makefile") == 1) then
		build_cmd = "make"
	end
	
	-- Default: ask user
	if not build_cmd then
		build_cmd = vim.fn.input("Build command (or press Enter to cancel): ")
		if build_cmd == "" then
			return
		end
	end
	
	-- Create floating popup with build command
	create_build_popup(build_cmd)
end, { desc = "Build project" })

-- Quick Swift build (for Swift projects)
vim.keymap.set("n", "<leader>bs", function()
	create_build_popup("swift build")
end, { desc = "Swift build" })

-- Search:
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- End Search
