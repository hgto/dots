local function system_lines(cmd, allowed_codes)
  local result = vim.system(cmd, { text = true }):wait()
  allowed_codes = allowed_codes or { [0] = true }
  if not allowed_codes[result.code] then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
    return nil
  end
  return vim.split(result.stdout, "\n", { trimempty = true })
end

vim.api.nvim_create_user_command("DeleteTrailingSpaces", function()
  local view = vim.fn.winsaveview()
  local search = vim.fn.getreg("/")
  vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
  vim.fn.setreg("/", search)
  vim.fn.winrestview(view)
end, {})

vim.api.nvim_create_user_command("Todo", function()
  local pattern = [[TODO|FIXME|XXX|BUG|ERROR|BLACKMAGIC]]
  local root_result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  local cmd
  if root_result.code == 0 then
    cmd = { "git", "-C", vim.trim(root_result.stdout), "grep", "-nE", pattern }
  else
    cmd = { "rg", "--vimgrep", pattern, "." }
  end
  local lines = system_lines(cmd, { [0] = true, [1] = true })
  if not lines then return end
  vim.fn.setqflist({}, " ", { title = "Todos", lines = lines })
  vim.cmd.copen()
end, {})

vim.api.nvim_create_user_command("Gdiffnames", function(opts)
  local base = opts.args ~= "" and opts.args or "HEAD"
  local lines = system_lines({ "git", "diff", "--name-only", base, "--" })
  if not lines then return end
  vim.fn.setqflist({}, " ", {
    title = "Files changed from " .. base,
    items = vim.iter(lines):map(function(path) return { filename = path, lnum = 1 } end):totable(),
  })
  vim.cmd.copen()
end, { nargs = "?", complete = "file" })

vim.keymap.set("n", "<leader>dts", "<cmd>DeleteTrailingSpaces<cr>", { desc = "Delete trailing spaces" })
