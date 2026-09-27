local plugin_specs = {
  { src = "https://github.com/Saghen/blink.cmp", rev = "8219b58f1c11" },
  { src = "https://github.com/mason-org/mason.nvim", rev = "2a6940af8037" },
  { src = "https://github.com/neovim/nvim-lspconfig", rev = "a9bb4d5f4276" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim", rev = "137bd0feba2c" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", rev = "443f1ef8b5e6" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", rev = "25a9b06a09ea" },
  { src = "https://github.com/stevearc/conform.nvim", rev = "016802de4025" },
  { src = "https://github.com/mfussenegger/nvim-lint", rev = "3d55c8f67c6a" },
  { src = "https://github.com/ibhagwan/fzf-lua", rev = "78b85d2a522b" },
  { src = "https://github.com/lewis6991/gitsigns.nvim", rev = "070a5d7b9855" },
  { src = "https://github.com/tpope/vim-fugitive", rev = "3b753cf8c6a4" },
  { src = "https://github.com/mrjones2014/smart-splits.nvim", rev = "ec76708f1617" },
  { src = "https://github.com/monaqa/dial.nvim", rev = "f2634758455c" },
  { src = "https://github.com/kylechui/nvim-surround", rev = "8b47db616ef6" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", rev = "58447c1fca35" },
  { src = "https://github.com/nvim-lua/plenary.nvim", rev = "74b06c6c75e4" },
  { src = "https://github.com/pwntester/octo.nvim", rev = "af2411604b51" },
  { src = "https://github.com/cocopon/iceberg.vim", rev = "23835d5ed696" },
  { src = "https://github.com/MunifTanjim/nui.nvim", rev = "10fc361835c8" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", rev = "162f9b953a69" },
}

vim.pack.add(plugin_specs, { confirm = false, load = true })

require("dots.completion")
require("dots.lsp")
require("dots.format")
require("dots.lint")
require("dots.treesitter")
require("dots.navigation")
require("dots.neotree")
require("dots.git")
require("dots.github")

vim.cmd.colorscheme("iceberg")

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update Neovim packages" })

local function plugin_name(src)
  return (src:gsub("%.git$", ""):match("([^/]+)$"))
end

vim.api.nvim_create_user_command("PackClean", function()
  local wanted = {}
  for _, spec in ipairs(plugin_specs) do
    wanted[spec.name or plugin_name(spec.src)] = true
  end

  local unused = {}
  for _, plug in ipairs(vim.pack.get()) do
    local name = plug.spec.name or plugin_name(plug.spec.src)
    if not wanted[name] then
      table.insert(unused, name)
    end
  end

  if #unused == 0 then
    vim.notify("PackClean: nothing to remove", vim.log.levels.INFO)
    return
  end

  local ok = vim.fn.confirm(
    "Remove unused plugin(s)?\n" .. table.concat(unused, "\n"),
    "&Yes\n&No"
  ) == 1
  if ok then
    vim.pack.del(unused)
  end
end, { desc = "Remove plugins not listed in plugins.lua (vim-plug's PlugClean equivalent)" })
