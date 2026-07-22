local M = {}

local function run(cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr ~= "" and result.stderr or result.stdout), vim.log.levels.ERROR)
    return nil
  end
  return vim.trim(result.stdout)
end

local function repository_root()
  local common = run({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" })
  if not common then return nil end
  return vim.fs.dirname(common)
end

local function launch(path, command)
  local nvim = vim.v.progpath
  local args = { nvim }
  if command then
    vim.list_extend(args, { "+" .. command })
  end

  if vim.env.TMUX then
    local words = { "cd", vim.fn.shellescape(path), "&&", "exec" }
    for _, arg in ipairs(args) do
      table.insert(words, vim.fn.shellescape(arg))
    end
    local tmux = { "tmux", "new-window", table.concat(words, " ") }
    vim.system(tmux, { text = true }, function(result)
      if result.code ~= 0 then
        vim.schedule(function()
          vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
        end)
      end
    end)
  else
    vim.notify(
      "A separate Neovim process requires tmux. Run: cd " .. vim.fn.shellescape(path) .. " && nvim",
      vim.log.levels.WARN
    )
  end
end

local function registered_worktree(root, path)
  local output = run({ "git", "worktree", "list", "--porcelain" }, root)
  if not output then return false end
  for registered in output:gmatch("worktree ([^\n]+)") do
    if vim.fs.normalize(registered) == vim.fs.normalize(path) then
      return true
    end
  end
  return false
end

function M.open(path, command)
  if vim.fn.isdirectory(path) ~= 1 then
    vim.notify("Not a worktree: " .. path, vim.log.levels.ERROR)
    return
  end
  launch(path, command)
end

function M.select()
  local root = repository_root()
  if not root then return end
  local output = run({ "git", "worktree", "list", "--porcelain" }, root)
  if not output then return end

  local worktrees = {}
  for path in output:gmatch("worktree ([^\n]+)") do
    table.insert(worktrees, path)
  end

  vim.ui.select(worktrees, {
    prompt = "Open worktree in new Neovim",
    format_item = function(path)
      local branch = run({ "git", "branch", "--show-current" }, path) or "detached"
      return string.format("%-24s %s", branch, path)
    end,
  }, function(path)
    if path then launch(path) end
  end)
end

function M.open_pr(number, repository)
  number = tonumber(number)
  if not number then
    vim.notify("PR number required", vim.log.levels.ERROR)
    return
  end

  local root = repository_root()
  if not root then return end

  repository = repository or run({ "gh", "repo", "view", "--json", "nameWithOwner", "--jq", ".nameWithOwner" }, root)
  if not repository then return end

  local name = "pr-" .. number
  local path = root .. "/.worktrees/" .. name
  local ref = "refs/remotes/origin/pr-" .. number
  local repo_url = "https://github.com/" .. repository .. ".git"

  if not run({ "git", "fetch", repo_url, "+refs/pull/" .. number .. "/head:" .. ref }, root) then
    return
  end

  if vim.fn.isdirectory(path) == 1 and not registered_worktree(root, path) then
    vim.notify(path .. " exists but is not a registered worktree", vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(path) ~= 1 then
    vim.fn.mkdir(root .. "/.worktrees", "p")
    local branch_exists = vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. name }, { cwd = root }):wait().code == 0
    if branch_exists then
      local branch_head = run({ "git", "rev-parse", name }, root)
      local pr_head = run({ "git", "rev-parse", ref }, root)
      if branch_head ~= pr_head then
        vim.notify("Branch " .. name .. " exists and does not match the PR head", vim.log.levels.ERROR)
        return
      end
    end
    local add = { "git", "worktree", "add" }
    if not branch_exists then vim.list_extend(add, { "-b", name }) end
    vim.list_extend(add, { path, branch_exists and name or ref })
    if not run(add, root) then
      return
    end
  else
    local status = run({ "git", "status", "--porcelain" }, path)
    if status == nil or status ~= "" then
      vim.notify("PR worktree has local changes; refusing to update: " .. path, vim.log.levels.ERROR)
      return
    end
    local branch = run({ "git", "branch", "--show-current" }, path)
    if branch ~= name then
      vim.notify("PR worktree is on unexpected branch " .. branch, vim.log.levels.ERROR)
      return
    end
    if not run({ "git", "merge", "--ff-only", ref }, path) then
      vim.notify("PR history changed; recreate the clean worktree before reviewing", vim.log.levels.ERROR)
      return
    end
  end

  local head = run({ "git", "rev-parse", "HEAD" }, path)
  local pr_head = run({ "git", "rev-parse", ref }, root)
  if head ~= pr_head then
    vim.notify("PR worktree contains commits not present in the PR", vim.log.levels.ERROR)
    return
  end

  launch(path, "Octo pr edit " .. number .. " " .. repository)
end

function M.select_pr()
  local repository = run({ "gh", "repo", "view", "--json", "nameWithOwner", "--jq", ".nameWithOwner" })
  if not repository then return end
  local output = run({ "gh", "pr", "list", "--repo", repository, "--limit", "100", "--json", "number,title,headRefName,author" })
  if not output then return end

  local ok, prs = pcall(vim.json.decode, output)
  if not ok then
    vim.notify("Could not parse gh pr list output", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(prs, {
    prompt = "Open PR in dedicated worktree",
    format_item = function(pr)
      return string.format("#%-5d %-24s %s", pr.number, pr.headRefName, pr.title)
    end,
  }, function(pr)
    if pr then M.open_pr(pr.number, repository) end
  end)
end

return M
