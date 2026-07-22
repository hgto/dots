local lint = require("lint")

lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
}

local group = vim.api.nvim_create_augroup("dots-lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  group = group,
  callback = function() lint.try_lint() end,
})

vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, { desc = "Lint buffer" })
