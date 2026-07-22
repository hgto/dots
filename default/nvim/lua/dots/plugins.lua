vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
  { src = "https://github.com/monaqa/dial.nvim" },
  { src = "https://github.com/kylechui/nvim-surround" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/pwntester/octo.nvim" },
  { src = "https://github.com/cocopon/iceberg.vim" },
}, { confirm = false, load = true })

require("dots.completion")
require("dots.lsp")
require("dots.format")
require("dots.lint")
require("dots.treesitter")
require("dots.navigation")
require("dots.git")
require("dots.github")

vim.cmd.colorscheme("iceberg")

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update Neovim packages" })
