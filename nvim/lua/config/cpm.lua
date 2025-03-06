local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept suggestion with Enter
    ["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
  },
  sources = {
    { name = "nvim_lsp" }, -- Enable LSP-based completion
    { name = "buffer" },
    { name = "path" },
  },
})

