local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    python = { "ruff_format" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    rust = { "rustfmt", lsp_format = "fallback" },
  },
})

local function format(opts)
  local range
  if opts and opts.range and opts.range > 0 then
    local first = math.min(opts.line1, opts.line2)
    local last = math.max(opts.line1, opts.line2)
    local line = vim.api.nvim_buf_get_lines(0, last - 1, last, false)[1] or ""
    range = {
      start = { first, 0 },
      ["end"] = { last, #line },
    }
  end
  conform.format({ async = true, lsp_format = "fallback", range = range })
end

vim.keymap.set("n", "<leader>lf", function() format() end, { desc = "Format" })
vim.keymap.set("x", "<leader>lf", function()
  local first = vim.fn.line("v")
  local last = vim.fn.line(".")
  format({ range = 1, line1 = math.min(first, last), line2 = math.max(first, last) })
end, { desc = "Format selection" })
vim.api.nvim_create_user_command("Format", format, { range = true })
vim.api.nvim_create_user_command("Prettier", function() format() end, {})
vim.api.nvim_create_user_command("FormatJSON", format, { range = true })
