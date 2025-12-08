local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Navigate completion menu
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Tab>"] = cmp_action.tab_complete(),
    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
    
    -- Confirm completion
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    
    -- Cancel completion
    ["<C-e>"] = cmp.mapping.abort(),
    
    -- Manually trigger completion
    ["<C-Space>"] = cmp.mapping.complete(),
    
    -- Navigate snippet placeholders
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  }),
  sources = {
    { name = "nvim_lsp", priority = 1000 }, -- LSP-based completion (highest priority)
    { name = "luasnip", priority = 750 },    -- Snippet completions
    { name = "buffer", priority = 500 },     -- Buffer words
    { name = "path", priority = 250 },       -- File paths
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Command line completion
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

