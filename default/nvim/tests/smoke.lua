assert(vim.fn.has("nvim-0.12") == 1)
assert(vim.g.mapleader == " ")
assert(vim.g.maplocalleader == "\\")
assert(vim.fn.exists(":Todo") == 2)
assert(vim.fn.exists(":Gdiffnames") == 2)
assert(vim.fn.exists(":DeleteTrailingSpaces") == 2)
assert(vim.fn.maparg("gb", "n") ~= "")
assert(vim.fn.maparg("<leader>b", "n") ~= "")
assert(vim.fn.maparg("<leader><leader>", "n") ~= "")

vim.cmd.enew()
vim.bo.filetype = "markdown"
assert(vim.bo.textwidth == 80)
for _, flag in ipairs({ "t", "n", "j", "1" }) do
  assert(vim.bo.formatoptions:find(flag, 1, true))
end

if not vim.env.SAFEVI then
  assert(vim.fn.exists(":Worktrees") == 2)
  assert(vim.fn.exists(":PRWorktree") == 2)
  assert(vim.fn.exists(":Octo") == 2)
  assert(vim.fn.exists(":Git") == 2)
  assert(vim.fn.exists("*FugitiveStatusline") == 1)
  assert(vim.fn.exists(":Mason") == 2)
  assert(vim.fn.exists(":PackUpdate") == 2)
  assert(vim.fn.exists(":TSInstallConfigured") == 2)
  assert(vim.fn.maparg("<leader>ff", "n") ~= "")
  assert(vim.fn.maparg("<leader>gP", "n") ~= "")
  assert(vim.fn.maparg("<leader>opl", "n") ~= "")
end

print("nvim-smoke-ok")
