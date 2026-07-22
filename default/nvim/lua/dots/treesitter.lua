local ts = require("nvim-treesitter")
ts.setup()

local parsers = { "lua", "bash", "python", "javascript", "typescript", "tsx", "rust", "vim", "vimdoc" }
vim.api.nvim_create_user_command("TSInstallConfigured", function()
  ts.install(parsers)
end, { desc = "Install configured Tree-sitter parsers" })

local supported = {
  lua = true,
  sh = true,
  bash = true,
  python = true,
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  rust = true,
  vim = true,
  help = true,
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("dots-treesitter", { clear = true }),
  callback = function(args)
    if supported[vim.bo[args.buf].filetype] then
      pcall(vim.treesitter.start, args.buf)
    end
  end,
})
