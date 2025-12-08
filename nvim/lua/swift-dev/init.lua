-- Swift development module for Neovim
-- This module contains all Swift-specific configurations

-- Note: swift.nvim plugin handles LSP setup automatically, so we don't need swift-dev.lsp
-- require("swift-dev.lsp")  -- Disabled: swift.nvim handles this
require("swift-dev.treesitter")
require("swift-dev.formatting")
require("swift-dev.linting")
require("swift-dev.snippets")
require("swift-dev.xcodebuild")
