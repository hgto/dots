require("blink.cmp").setup({
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  completion = { documentation = { auto_show = false } },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
