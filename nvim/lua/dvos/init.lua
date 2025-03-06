require("dvos.remap")
require("config.lazy")
require("config.cpm")

-- Make the background transpara
vim.cmd [[
  highlight Normal guibg=non
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none]]

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false

-- Relativ line number and font settings
vim.wo.relativenumber = true
vim.g.have_nerd_font = true

-- Enable break indent
vim.opt.breakindent = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Save undo history
vim.opt.undofile = true

