if vim.fn.has("nvim-0.12") ~= 1 then
  error("This configuration requires Neovim 0.12 or newer")
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("dots.options")
require("dots.keymaps")
require("dots.autocmds")
require("dots.commands")

if not vim.env.SAFEVI then
  require("dots.plugins")
end
