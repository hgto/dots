local group = vim.api.nvim_create_augroup("dots", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  callback = function() vim.cmd.wincmd("=") end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 1 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "mail", "tex" },
  callback = function() vim.opt_local.textwidth = 72 end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "text", "mail" },
  callback = function()
    vim.opt_local.formatoptions:append({ "t", "n", "j", "1" })
    vim.opt_local.comments = "n:>,n:*,n:+,n:-"
    if vim.bo.filetype == "markdown" then
      vim.opt_local.textwidth = 80
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "crontab",
  callback = function()
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
  end,
})
