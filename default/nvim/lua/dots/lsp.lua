local servers = { "lua_ls", "bashls", "basedpyright", "ts_ls", "eslint", "rust_analyzer", "vimls" }

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = false,
})
require("mason-tool-installer").setup({
  ensure_installed = { "stylua", "shfmt", "shellcheck", "ruff", "prettierd", "tree-sitter-cli" },
  run_on_start = true,
  auto_update = false,
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    },
  },
})
vim.lsp.enable(servers)

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = true },
})

local group = vim.api.nvim_create_augroup("dots-lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("<leader>ld", vim.lsp.buf.definition, "LSP definition")
    map("<leader>li", vim.lsp.buf.implementation, "LSP implementation")
    map("<leader>lr", vim.lsp.buf.references, "LSP references")
    map("<leader>ln", vim.lsp.buf.rename, "LSP rename")
    map("<leader>la", vim.lsp.buf.code_action, "LSP code action")
    map("<leader>ls", vim.lsp.buf.document_symbol, "Document symbols")
  end,
})
