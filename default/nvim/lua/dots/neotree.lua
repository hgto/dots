require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = {
        ["<cr>"] = "open",
        ["o"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
      },
    },
  },
})

local map = vim.keymap.set
map("n", "<C-n>", "<Cmd>Neotree toggle<CR>", { desc = "Toggle file tree" })
