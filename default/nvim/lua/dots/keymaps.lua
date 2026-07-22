local map = vim.keymap.set

map("x", ">", ">gv", { desc = "Indent and reselect" })
map("x", "<", "<gv", { desc = "Outdent and reselect" })
map("n", "gb", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "gB", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "vq", "vapgq", { desc = "Format paragraph" })
map("x", "Q", "gqq", { desc = "Format selection" })
map("n", "<leader><leader>", "<cmd>nohlsearch<cr><c-l>", { desc = "Clear search" })

for _, key in ipairs({ "*", "#", "g*", "g#", "n", "N", "<C-]>" }) do
  map("n", key, key .. "zz", { silent = true })
end

map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })
map({ "n", "x" }, "<leader>b", '"_', { remap = true, desc = "Black-hole register" })

map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
map("n", "]Q", "<cmd>cnfile<cr>", { desc = "Next quickfix file" })
map("n", "[Q", "<cmd>cpfile<cr>", { desc = "Previous quickfix file" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next location item" })
map("n", "[l", "<cmd>lprevious<cr>", { desc = "Previous location item" })
map("n", "]L", "<cmd>lnfile<cr>", { desc = "Next location file" })
map("n", "[L", "<cmd>lpfile<cr>", { desc = "Previous location file" })

map("n", "<leader>v", "<cmd>Vexplore<cr>", { desc = "Explorer" })
map("n", "<leader>on", "<cmd>setlocal number!<cr>", { desc = "Toggle numbers" })
map("n", "<leader>or", "<cmd>setlocal relativenumber!<cr>", { desc = "Toggle relative numbers" })
map("n", "<leader>os", "<cmd>setlocal spell!<cr>", { desc = "Toggle spelling" })
map("n", "<leader>ow", "<cmd>setlocal wrap!<cr>", { desc = "Toggle wrapping" })
map("n", "<leader>ol", "<cmd>setlocal list!<cr>", { desc = "Toggle whitespace" })
map("n", "<leader>om", "<cmd>setlocal modifiable!<cr>", { desc = "Toggle modifiable" })
map("n", "<leader>occ", "<cmd>setlocal cursorcolumn!<cr>", { desc = "Toggle cursor column" })
map("n", "<leader>ocl", "<cmd>setlocal cursorline!<cr>", { desc = "Toggle cursor line" })
map("n", "<leader>ocb", function()
  vim.opt.clipboard = vim.o.clipboard == "unnamedplus" and "" or "unnamedplus"
  vim.notify("clipboard=" .. vim.o.clipboard)
end, { desc = "Toggle system clipboard" })

for suffix, target in pairs({ r = "REMOTE", b = "BASE", l = "LOCAL" }) do
  map("n", "dg" .. suffix, "<cmd>diffget " .. target .. "<cr>", { desc = "Diffget " .. target })
  map("n", "<leader>dg" .. suffix, "<cmd>diffget " .. target .. "<cr>", { desc = "Diffget " .. target })
end

map("n", "<leader>rc", function()
  vim.cmd.tabnew(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit Neovim config" })
map("n", "<leader>rp", function()
  vim.cmd.tabnew(vim.fn.stdpath("config") .. "/lua/dots/plugins.lua")
end, { desc = "Edit plugin config" })
map("n", "<leader>rl", function()
  vim.cmd.tabnew(vim.fn.stdpath("config") .. "/lua/dots/local.lua")
end, { desc = "Edit local config" })

local function insert(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
  vim.api.nvim_win_set_cursor(0, { row, col + #text })
end

map("n", "<leader>zld", function() insert(os.date("%d.%m.%Y")) end, { desc = "Insert local date" })
map("n", "<leader>zlt", function() insert(os.date("%d.%m.%Y %H:%M %z")) end, { desc = "Insert local timestamp" })
map("n", "<leader>zt", function() insert(os.date("!%Y%m%dT%H%MZ")) end, { desc = "Insert UTC timestamp" })
map("n", "<leader>zd", function() insert(os.date("!%Y%m%d")) end, { desc = "Insert UTC date" })
map("n", "<leader>zy", function() insert("[hgto // " .. os.date("!%Y%m%dT%H%MZ") .. "]") end, { desc = "Insert hgto signature" })
map("n", "<leader>zz", function() insert("[" .. (vim.env.USER or "user") .. " // " .. os.date("!%Y%m%dT%H%MZ") .. "]") end, { desc = "Insert signature" })

local local_config = vim.fn.stdpath("config") .. "/lua/dots/local.lua"
if vim.uv.fs_stat(local_config) then
  dofile(local_config)
end
