local fzf = require("fzf-lua")
fzf.setup({
  winopts = { height = 0.75, width = 0.9, preview = { layout = "flex" } },
  files = { fd_opts = "--color=never --type f --hidden --follow --exclude .git" },
})
fzf.register_ui_select()

local map = vim.keymap.set
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>fG", fzf.git_files, { desc = "Git files" })
map("n", "<leader>fs", fzf.git_status, { desc = "Git status files" })
map("n", "<leader>fl", fzf.blines, { desc = "Buffer lines" })
map("n", "<leader>fL", fzf.lines, { desc = "Loaded buffer lines" })
map("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
map("n", "<leader>fm", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fp", function() fzf.files({ cwd = vim.fn.expand("~/Projects") }) end, { desc = "Projects" })

local splits = require("smart-splits")
splits.setup({ at_edge = "wrap" })
map("n", "<C-h>", splits.move_cursor_left)
map("n", "<C-j>", splits.move_cursor_down)
map("n", "<C-k>", splits.move_cursor_up)
map("n", "<C-l>", splits.move_cursor_right)

require("nvim-surround").setup()
