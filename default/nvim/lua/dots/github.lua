require("octo").setup({
  picker = "fzf-lua",
  enable_builtin = true,
  picker_config = {
    use_emojis = false,
    search_static = true,
  },
  file_panel = { icons = true },
  reviews = {
    auto_show_threads = true,
    focus = "right",
  },
})

local worktrees = require("dots.worktrees")

vim.api.nvim_create_user_command("Worktrees", worktrees.select, { desc = "Open a worktree in new Neovim" })
vim.api.nvim_create_user_command("PRWorktree", function(opts)
  if opts.args == "" then
    worktrees.select_pr()
  else
    worktrees.open_pr(opts.args)
  end
end, { nargs = "?", desc = "Open a PR in a dedicated worktree" })

local map = vim.keymap.set
map("n", "<leader>gw", worktrees.select, { desc = "Open worktree" })
map("n", "<leader>gP", worktrees.select_pr, { desc = "Open PR worktree" })
map("n", "<leader>opl", "<cmd>Octo pr list<cr>", { desc = "List pull requests" })
map("n", "<leader>opr", "<cmd>Octo review start<cr>", { desc = "Start PR review" })
map("n", "<leader>opR", "<cmd>Octo review resume<cr>", { desc = "Resume PR review" })
map("n", "<leader>opc", "<cmd>Octo pr checks<cr>", { desc = "PR checks" })
map("n", "<leader>ops", "<cmd>Octo review submit<cr>", { desc = "Submit PR review" })
